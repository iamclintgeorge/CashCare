'use client'
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import axios from 'axios';
import Header from "../Components/Header";
import Footer from '../Components/Footer';

const ForgotPassword = () => {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:3001/api/forgot-password', { email });
      setMessage("If the email is registered, you will receive a password reset link.");
    } catch (error) {
      setMessage("An error occurred. Please try again.");
    }
  };

  return (
    <div>
    <Header />
        <div className="min-h-screen flex items-center justify-center">
        <form onSubmit={handleSubmit} className="bg-white p-6 rounded shadow-md">
            <h2 className="text-lg font-bold mb-4">Forgot Password</h2>
            <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Enter your email"
            className="border p-2 rounded w-full mb-4"
            required
            />
            <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">
            Send Reset Link
            </button>
            {message && <p className="mt-4 text-gray-700">{message}</p>}
        </form>
        </div>
    </div>
  );
};

export default ForgotPassword;
