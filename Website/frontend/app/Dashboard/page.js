'use client';
import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Header1 from "../Components/Header1";
import Herosec from "../Sections/Herosec";
import Whycashcare from "../Sections/Whycashcare";
import Pricing from "../Sections/Pricing";
import Footer from "../Components/Footer";

function Dashboard() {
  const [protectedData, setProtectedData] = useState(null);
  const [error, setError] = useState(null);
  const router = useRouter(); // Initialize the router for redirection

  useEffect(() => {
    // Fetch protected data from the backend
    const fetchProtectedData = async () => {
      try {
        const response = await fetch('http://localhost:3001/api/protected', {
          method: 'GET',
          credentials: 'include', // Send cookies with the request
        });

        if (response.ok) {
          const data = await response.json();
          setProtectedData(data);
        } else {
          // If response is not ok, set error
          setError('Access denied. Please log in.');    
          router.push('/Login');
        }
      } catch (err) {
        setError('Error fetching protected data.');
        console.error('Error:', err);
        router.push('/Login');
      }
    };

    fetchProtectedData();
  }, [router]);


   // Logout function to clear the token and redirect to login page
   const handleLogout = async () => {
    try {
      // Clear the token cookie
      await fetch('http://localhost:3001/api/logout', {
        method: 'POST',
        credentials: 'include', // Ensure cookies are included in the request
      });

      // Redirect to login page
      router.push('/Login');
    } catch (err) {
      console.error('Error logging out:', err);
    }
  };

  return (
    <div>
      {error && <div>{error}</div>}
      {protectedData ? (
        <div>
          {/* <h1 className='ml-4'>Welcome to the Dashboard </h1> */}
          {/* <p>{protectedData.message}</p> */}
            <Header1 />
            <Herosec />
            <Whycashcare />
            <Pricing />
            <Footer />
            {/* <div className=''>
              <button onClick={handleLogout} className="bg-red-500 text-white px-4 py-2 rounded mr-4">
                Logout
              </button>
            </div> */}
        </div>
      ) : (
        <div>Loading...</div>
      )}
    </div>
  );
}

export default Dashboard;

