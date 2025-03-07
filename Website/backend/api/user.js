// pages/api/user.js
import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

// Initialize the PostgreSQL database connection pool
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

export default async (req, res) => {
  const { id } = req.query; // Destructuring to get userId from the query params

  // Check if userId is provided
  if (!id) {
    return res.status(400).json({ error: 'User ID is required' });
  }

  try {
    // Query the database for the user's name using the userId
    const result = await pool.query('SELECT name FROM users WHERE id = $1', [id]);

    if (result.rows.length > 0) {
      // If a user is found, return the name
      res.status(200).json({ name: result.rows[0].name });
    } else {
      // If no user is found with the given ID
      res.status(404).json({ error: 'User not found' });
    }
  } catch (error) {
    // Log the error and respond with a 500 server error
    console.error('Database error:', error);
    res.status(500).json({ error: 'Database error' });
  }
};
