'use client'
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import axios from 'axios';
import Cookies from 'js-cookie';  // Import js-cookie to handle cookies
import '@fortawesome/fontawesome-free/css/all.min.css';
import Header from "../Components/Header";
import Footer from '';

const Login = () => {
  const [showPassword, setShowPassword] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const router = useRouter();



  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:3001/api/login', {
        email,
        password,
      }, { withCredentials: true });  // Allow cookies to be sent

      if (response.data.success) {
        // The token is automatically stored in the cookie by the backend
        router.push('/Dashboard');  // Redirect after successful login
      }
    } catch (err) {
      setError("Invalid email or password");
    }
  };

  return (
    <section className="bg-gray-200">
      <Header />
      <div className="w-full lg:w-4/12 px-4 mx-auto pt-6">
        <div className="relative flex flex-col min-w-0 break-words w-full mb-6 shadow-lg rounded-lg bg-blueGray-200 border-0">
          <div className="rounded-t mb-0 px-6 py-6 bg-slate-100">
            <div className="text-center mb-2">
              <h4 className="text-black text-2xl font-bold">Welcome back</h4>
                <div className="mt-3">
                  <small>Please enter your details</small>
                </div>
            </div>
          </div>
          <div className="flex-auto px-4 lg:px-10 py-10 pt-0 bg-slate-100">
            <form onSubmit={handleSubmit}>
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
                    type={showPassword ? "text" : "password"}
                    id="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="border-0 px-3 py-3 placeholder-blueGray-300 text-black bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
                    placeholder="Password"
                  />
                  <i
                    onClick={() => setShowPassword(!showPassword)}
                    className={`fas ${showPassword ? 'fa-eye-slash' : 'fa-eye'} absolute top-1/2 right-3 transform -translate-y-1/2 cursor-pointer`}
                  ></i>
                </div>
              </div>
              {error && <div className="text-red-500 text-sm">{error}</div>}
              <div className='flex justify-between'>
              
                <label className="inline-flex items-center cursor-pointer">
                  <input
                    id="customCheckLogin"
                    type="checkbox"
                    className="form-checkbox border-0 rounded text-blueGray-700 ml-1 w-5 h-5 ease-linear transition-all duration-150"
                  />
                  <span className="ml-2 text-sm font-semibold text-black">Remember me</span>
                </label>
                    <p className="text-sm text-gray-500 justify-end">
                     {" "}
                    <button
                      onClick={() => router.push("/Forgotpassword")}
                      className="text-blue-500 font-semibold hover:underline"
                    >
                      forgot password?
                    </button>
                    </p>
              </div>





              <div className="text-center mt-6">
                <button
                  className="bg-slate-50 text-black active:bg-gray-100 text-sm font-bold uppercase px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 w-full ease-linear transition-all duration-150"
                  type="submit"
                  title="Login"
                >
                  Login
                </button>
              </div>
            </form>
            <div className="text-center mt-4">
              <p className="text-sm text-gray-500">
              Don't have an account?{" "}
                <button
                  onClick={() => router.push("/Signup")}
                  className="text-blue-500 font-semibold hover:underline"
                >
                  Signup
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

export default Login;
