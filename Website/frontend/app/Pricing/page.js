'use client';
import React from 'react';
import Header from "../Components/Header";
import Footer from '../Components/Footer';


const PricingTable = () => {
  return (
    <div className="bg-gray-200">
    <Header />
      <h1 className="text-3xl font-bold text-center mb-4 mt-16">Transparent pricing that scales with your needs</h1>
      <p className="text-center mb-8">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ac ultricies libero,<br></br> vitae commodo dolor. Sed fermentum semper ex a varius..</p>
      <div className="flex justify-center mb-20">
      <table className="min-w-1.5 text-left bg-gray-300 border border-gray-400 rounded-lg">
        <thead>
          <tr className="bg-gray-50">  
            <th className="px-4 py-2 border border-gray-400">Features</th>
            <th className="px-4 py-2 text-center border border-gray-400">Free Plan</th>
            <th className="px-4 py-2 text-center border border-gray-400">Premium</th>
            <th className="px-4 py-2 text-center border border-gray-400">Enterprise</th>
          </tr>
        </thead>
        <tbody>
          <tr className="border-b bg-gray-50">
            <td className="px-4 py-2 border border-gray-400">Credit Card Fraud Detection</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-red-600">❌</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
          </tr>
          <tr className="border-b bg-gray-50">
            <td className="px-4 py-2 border border-gray-400">Online Payment Fraud Detection</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-red-600">❌</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
          </tr>
          <tr className="border-b bg-gray-50">
            <td className="px-4 py-2 border border-gray-400">Context Aware Firewall</td>
            <td className="px-4 py-2 text-center border border-gray-400">❌</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
          </tr>
          <tr className="border-b bg-gray-50">
            <td className="px-4 py-2 border border-gray-400">Spam Detection</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
          </tr>
          <tr className="border-b bg-gray-50">
            <td className="px-4 py-2 border border-gray-400">Email Spam Detection</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
          </tr>
          <tr className="border-b bg-gray-50">
            <td className="px-4 py-2 border border-gray-400">SMS Spam Detection</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
          </tr>
          <tr className="border-b bg-gray-50">
            <td className="px-4 py-2 border border-gray-400">Financial Monitoring</td>
            <td className="px-4 py-2 text-center border border-gray-400">❌</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
          </tr>
          <tr className="border-b bg-gray-50">
            <td className="px-4 py-2 border border-gray-400">Custom Services</td>
            <td className="px-4 py-2 text-center border border-gray-400">❌</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">❌</td>
            <td className="px-4 py-2 text-center border border-gray-400 text-green-600">✅</td>
          </tr>
        </tbody>
      </table>
      </div>
      <Footer />
    </div>
  );
};

export default PricingTable;