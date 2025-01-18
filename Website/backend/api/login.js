import { Pool } from 'pg';
import express from 'express';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import cors from 'cors'; // Import cors
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const router = express.Router();

// CORS configuration
const corsOptions = {
  origin: 'http://localhost:3000', // Your frontend URL
  credentials: true, // Allow cookies to be sent with requests
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Allowed methods
};

// Apply CORS middleware globally
app.use(cors(corsOptions));

// Parse incoming JSON requests
app.use(express.json());

// Database connection setup
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});


// API route for login
router.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    // Query the database for the user by email
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);

    if (result.rows.length === 0) {
      return res.status(400).json({ message: 'User not found' });
    }

    const user = result.rows[0];

    // Validate the password with bcrypt
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid password' });
    }

    // Generate a JWT token
    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET || 'default_secret', { expiresIn: '1h' });

    // Send the token as a secure, HttpOnly cookie
    res.cookie('token', token, {
      httpOnly: true, // Ensures the cookie is not accessible via JavaScript (for security)
      secure: process.env.NODE_ENV === 'production', // Only set the Secure flag in production
      sameSite: 'strict', // Helps prevent cross-site request forgery (CSRF)
      maxAge: 3600000, // Cookie expiration time (1 hour)
    });

    res.json({ success: true, message: 'Logged in successfully' });

  } catch (error) {
    console.error('Error during login process', error);
    res.status(500).json({ message: 'Error logging in user' });
  }
});

// Register the login router with the app
app.use(router);

// Start the server
const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

export default app;



  