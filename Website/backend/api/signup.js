import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

export default async function handler(req, res) {
  if (req.method === 'POST') {
    const { name, email, password } = req.body;

    const query = `
      INSERT INTO users (name, email, password)
      VALUES ($1, $2, $3)
      RETURNING id, name, email
    `;
    const values = [name, email, password];

    try {
      const result = await pool.query(query, values);  // Use pool.query instead of client.query

      res.status(200).json({
        success: true,
        message: 'User registered successfully',
        user: result.rows[0],
      });
    } catch (error) {
      console.error('Error inserting data into the database', error);
      res.status(500).json({
        success: false,
        message: 'Error registering user',
      });
    }
  } else {
    res.status(405).json({ success: false, message: 'Method Not Allowed' });
  }
}
























