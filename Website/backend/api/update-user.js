import { Pool } from "pg";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";
import dotenv from "dotenv";

dotenv.config();

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

export default async function handler(req, res) {
  if (req.method !== "PUT") {
    return res.status(405).json({ message: "Method Not Allowed" });
  }

  const token = req.cookies.token;
  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || "default_secret");
    const userId = decoded.id;
    const { name, password } = req.body;

    let query = "UPDATE users SET name = $1";
    let values = [name];

    if (password) {
      const hashedPassword = await bcrypt.hash(password, 10);
      query += ", password = $2 WHERE id = $3 RETURNING name";
      values = [name, hashedPassword, userId];
    } else {
      query += " WHERE id = $2 RETURNING name";
      values = [name, userId];
    }

    const result = await pool.query(query, values);
    res.status(200).json({ success: true, name: result.rows[0].name });
  } catch (error) {
    console.error("Error updating user:", error);
    res.status(500).json({ success: false, message: "Error updating user" });
  }
}