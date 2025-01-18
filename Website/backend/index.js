const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');
const cookieParser = require('cookie-parser');
const cors = require('cors');
require('dotenv').config();

const app = express();
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// CORS Configuration for allowing credentials (cookies)
const corsOptions = {
  origin: 'http://localhost:3000',  // Frontend URL
  credentials: true,  // Allow sending cookies (credentials) with requests
  methods: ['GET', 'POST', 'PUT', 'DELETE'],  // Allowed HTTP methods
};

app.use(cors(corsOptions));  // Apply CORS middleware with options
app.use(express.json());  // Middleware for parsing JSON
app.use(cookieParser());  // Middleware for cookie parsing

// Signup Route
app.post('/api/signup', async (req, res) => {
  const { name, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(String(password), 10);

  try {
    console.log('Attempting to sign up with:', name, email, password);  // For debugging

    const result = await pool.query(
      'INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING *',
      [name, email, hashedPassword]
    );

    console.log('User signed up successfully:', result.rows[0]);  // For debugging
    res.json({ success: true, user: result.rows[0] });
  } catch (err) {
    console.error('Error signing up user:', err);
    res.status(500).json({ success: false, message: 'Error signing up user' });
  }
});

// Login Route
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);

    if (result.rows.length === 0) {
      return res.status(400).json({ message: 'User not found' });
    }

    const user = result.rows[0];
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Invalid password' });
    }

    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.cookie('token', token, { 
      httpOnly: true,  // Prevent access via JavaScript
      secure: process.env.NODE_ENV === 'production',  // Use secure cookies only in production (set to false in development)
      sameSite: 'Strict',  // Help prevent CSRF attacks
      maxAge: 3600000  // Cookie expiration time (1 hour)
    });

    res.json({ success: true, message: 'Logged in successfully' });
  } catch (err) {
    console.error('Error logging in user:', err);
    res.status(500).json({ message: 'Error logging in user' });
  }
});

// Protect Route Middleware
const authenticateToken = (req, res, next) => {
  const token = req.cookies.token;

  if (!token) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  jwt.verify(token, process.env.JWT_SECRET , (err, user) => {
    if (err) {
      return res.status(403).json({ message: 'Token is not valid' });
    }
    req.user = user;
    next();
  });
};

// Import the logout route
const logoutRoute = require('./api/logout');

// Use the logout route
app.use('/api/logout', logoutRoute);

// Protected Route
app.get('/api/protected', authenticateToken, (req, res) => {
  res.json({ message: 'This is a protected route', user: req.user });
});

app.listen(3001, () => {
  console.log('Server is running on http://localhost:3001');
});
