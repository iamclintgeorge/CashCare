'use client';
import React from "react";
import { useRouter } from 'next/navigation';

const Herosec = () => {

  const router = useRouter(); // Initialize the router

  const handleGetStarted = () => {
    router.push('/Login'); // Redirect to the login page
  };


  return (
    <>
      {/* <div>Hello Welcome to Hero Section</div> */}
      {/* for styling directly size={60} */}
      <div className="place-content-center text-center bg-gray-200">
        <main className="flex flex-col items-center justify-center h-screen text-center ">
          <h2 className="text-6xl font-bold mb-5">
            <span className="text-black">
              Find clients who <br></br>just raised
            </span>{" "}
            <span className="text-orange-800">Venture Capital</span>
          </h2>
          <p className="mt-4 mb-5 text-base text-black">
            Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit. Vestibulum
            Ac Ultricies Libero,<br></br> Vitae Commodo Dolor. Sed Fermentum
            Semper Ex A Varius.
          </p>
          {/* <button className="mt-5 px-4 py-2 bg-gray-800 text-white rounded">
          <a href="/get-started">GET STARTED</a>
        </button> */}
          <button  onClick={handleGetStarted} className="mt-5 px-7 py-2 bg-black text-white rounded-md flex items-center justify-center">
            <span className="text-sm tracking-widest">GET STARTED</span>
            <span className="ml-2 mb-1">&rarr;</span>
          </button>
        </main>
      </div>
    </>
  );
};

export default Herosec;
