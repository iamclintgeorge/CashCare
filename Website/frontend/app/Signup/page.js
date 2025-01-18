'use client'
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import '@fortawesome/fontawesome-free/css/all.min.css'; // Ensure Font Awesome is imported
import Header from "../Components/Header";
import Footer from '../Components/Footer';

const Signup = () => {
  const [showPassword, setShowPassword] = useState(false); // Toggle password visibility
  const [name, setName] = useState(""); // Store name input
  const [email, setEmail] = useState(""); // Store email input
  const [password, setPassword] = useState(""); // Store password input
  const [confirmPassword, setConfirmPassword] = useState(""); // Store confirm password input
  const router = useRouter(); // Router for navigation

  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault();  // Prevent default form submission

    if (password !== confirmPassword) {
      alert('Passwords do not match');
      return;
    }

    const response = await fetch('http://localhost:3001/api/signup', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ name, email, password }),
    });

    const data = await response.json();
    if (data.success) {
      router.push('/Login');
    } else {
      alert(data.message);
    }
  };

  return (
    <section className="bg-gray-200">
      <Header />
      <div className="w-full lg:w-4/12 px-4 mx-auto pt-6">
        <div className="relative flex flex-col min-w-0 break-words w-full mb-6 shadow-lg rounded-lg bg-blueGray-200 border-0">
          <div className="rounded-t mb-0 px-6 py-6 bg-slate-100">
            <div className="text-center mb-3">
              {/* <div className="text-center mb-3 text-black">
                <small>Start your journey</small>
              </div> */}
            <h6 className="text-black text-[24px] font-bold">Sign up to CashCare</h6>
            </div>
            {/* <div className="btn-wrapper text-center">
              <button
                className="bg-white active:bg-blueGray-50 text-black font-normal px-4 py-2 rounded outline-none focus:outline-none mr-2 mb-1 uppercase shadow hover:shadow-md inline-flex items-center text-xs ease-linear transition-all duration-150"
                type="button"
              >
                <img
                  alt="..."
                  className="w-5 mr-1"
                  src="https://demos.creative-tim.com/notus-js/assets/img/github.svg"
                />
                Github
              </button>
              <button
                className="bg-white active:bg-blueGray-50 text-black font-normal px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 uppercase shadow hover:shadow-md inline-flex items-center text-xs ease-linear transition-all duration-150"
                type="button"
              >
                <img
                  alt="..."
                  className="w-5 mr-1"
                  src="https://demos.creative-tim.com/notus-js/assets/img/google.svg"
                />
                Google
              </button>
            </div> */}
          </div>
          <div className="flex-auto px-4 lg:px-10 py-10 pt-0 bg-slate-100">
            
            <form onSubmit={handleSubmit}> {/* Added onSubmit handler */}
              <div className="relative w-full mb-3">
                <label className="block uppercase text-black text-xs font-bold mb-2" htmlFor="name">
                  Name
                </label>
                <input
                  type="text"
                  id="name"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="border-0 px-3 py-3 placeholder-blueGray-300 text-black bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
                  placeholder="Name"
                />
              </div>
              <div className="relative w-full mb-3">
                <label className="block uppercase text-black text-xs font-bold mb-2" htmlFor="email">
                  Email
                </label>
                <input
                  type="email"
                  id="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="border-0 px-3 py-3 placeholder-blueGray-300 text-black bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
                  placeholder="Email"
                />
              </div>
              <div className="relative w-full mb-3">
                <label className="block uppercase text-black text-xs font-bold mb-2" htmlFor="password">
                  Password
                </label>
                <div className="relative">
                  <input
                    type={showPassword ? "text" : "password"} // Toggle between text and password type
                    id="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="border-0 px-3 py-3 placeholder-blueGray-300 text-black bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
                    placeholder="Password"
                  />
                  <i
                    onClick={() => setShowPassword(!showPassword)} // Toggle visibility on click
                    className={`fas ${showPassword ? 'fa-eye-slash' : 'fa-eye'} absolute top-1/2 right-3 transform -translate-y-1/2 cursor-pointer`}
                  ></i>
                </div>
              </div>
              <div className="relative w-full mb-3">
                <label className="block uppercase text-black text-xs font-bold mb-2" htmlFor="confirm-password">
                  Confirm Password
                </label>
                <div className="relative">
                  <input
                    type={showPassword ? "text" : "password"} // Toggle between text and password type
                    id="confirm-password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    className="border-0 px-3 py-3 placeholder-blueGray-300 text-black bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
                    placeholder="Confirm Password"
                  />
                  <i
                    onClick={() => setShowPassword(!showPassword)} // Toggle visibility on click
                    className={`fas ${showPassword ? 'fa-eye-slash' : 'fa-eye'} absolute top-1/2 right-3 transform -translate-y-1/2 cursor-pointer`}
                  ></i>
                </div>
              </div>
              <div>
                {/* <label className="inline-flex items-center cursor-pointer">
                  <input
                    id="customCheckSignup"
                    type="checkbox"
                    className="form-checkbox border-0 rounded text-blueGray-700 ml-1 w-5 h-5 ease-linear transition-all duration-150"
                  />
                  <span className="ml-2 text-sm font-semibold text-black">Remember me</span>
                </label> */}
              </div>
              <div className="text-center mt-6">
              <button
                className="bg-slate-50 text-black active:bg-white text-sm font-bold uppercase px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 w-full ease-linear transition-all duration-150"
                type="submit" // Changed to submit button
                title="Sign Up"
              >
                Sign Up
              </button>
              </div>
            </form>
            <div className="text-center mt-4">
              <p className="text-sm text-gray-500">
                Already have an account?{" "}
                <button
                  onClick={() => router.push("/Login")}
                  className="text-blue-500 font-semibold hover:underline"
                >
                  Login
                </button>
              </p>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </section>
  );
};

export default Signup;

