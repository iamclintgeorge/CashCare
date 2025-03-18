import React, { useState, useEffect } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";

const Header1 = () => {
  const [user, setUser] = useState(null);
  const [menuVisible, setMenuVisible] = useState(false);
  const router = useRouter();

  // Fetch user data after login
  useEffect(() => {
    const fetchUserData = async () => {
      try {
        // Step 1: Call /api/protected to get the user ID
        const protectedResponse = await fetch("http://localhost:3001/api/protected", {
          method: "GET",
          credentials: "include", // Include cookies (JWT token)
        });

        if (!protectedResponse.ok) {
          console.error("Failed to fetch protected data:", protectedResponse.status, await protectedResponse.text());
          setUser(null);
          router.push("/Login");
          return;
        }

        const protectedData = await protectedResponse.json();
        console.log("API Response from /api/protected:", protectedData); // Debug: Check the response
        const userId = protectedData.user?.id;

        if (!userId) {
          console.error("User ID not found in /api/protected response");
          setUser(null);
          router.push("/Login");
          return;
        }

        // Step 2: Call /api/username on the backend to get the name
        const userResponse = await fetch(`http://localhost:3001/api/username?id=${userId}`, {
          method: "GET",
          credentials: "include", // Include cookies since /api/username is protected
        });

        if (!userResponse.ok) {
          console.error("Failed to fetch user data:", userResponse.status, await userResponse.text());
          setUser(null);
          router.push("/Login");
          return;
        }

        const userData = await userResponse.json();
        console.log("API Response from /api/username:", userData); // Debug: Check the response
        const userName = userData.name || "Unknown";
        console.log("Setting user name to:", userName); // Debug: Confirm the name
        setUser({ name: userName });
      } catch (error) {
        console.error("Error fetching user data:", error);
        setUser(null);
        router.push("/Login");
      }
    };

    fetchUserData();
  }, [router]);

  const toggleMenu = () => {
    setMenuVisible(!menuVisible);
  };

  const handleSignOut = async () => {
    try {
      await fetch("http://localhost:3001/api/logout", {
        method: "POST",
        credentials: "include",
      });
      setUser(null);
      router.push("/Login");
    } catch (error) {
      console.error("Error signing out:", error);
    }
  };

  return (
    <div className="bg-gray-200 bg-opacity-85 backdrop-blur-md sticky top-0 z-50 pt-5 pb-3 transition-all duration-300">
      <div className="flex justify-around items-center">
        <div className="font-extrabold tracking-widest text-lg leading-5">
          <Link href="/" passHref>
            <p>CASH</p>
            <p>CARE</p>
          </Link>
        </div>
        <ul className="flex gap-10 items-center text-sm tracking-widest">
          <li><Link href="/">HOME</Link></li>
          <li><Link href="/Pricing">PRICING</Link></li>
          <li>PRODUCTS</li>
          <li>RESOURCES</li>
          <li>CONTACT US</li>
        </ul>
        <ul className="flex gap-5 items-center text-xs tracking-widest">
          {!user ? (
            <li className="border rounded-2xl px-5 py-2 border-black hover:bg-gray-300 transition">
              <Link href="/Signup">SIGN IN</Link>
            </li>
          ) : (
            <li className="relative">
              <div
                onClick={toggleMenu}
                className="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-500 text-white flex items-center justify-center rounded-full cursor-pointer hover:shadow-lg transition-shadow"
              >
                {user.name ? user.name[0].toUpperCase() : "?"}
              </div>
              {menuVisible && (
                <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-xl p-4 z-50">
                  <p className="text-gray-800 text-base font-bold mb-3 tracking-wide">
                    Hey, {user.name || "Friend"}!
                  </p>
                  <ul className="text-gray-600">
                    <li className="py-2 px-2 hover:bg-gray-100 rounded cursor-pointer">
                      <Link href="/Settings">Settings</Link>
                    </li>
                    <li
                      className="py-2 px-2 hover:bg-gray-100 rounded cursor-pointer text-red-500"
                      onClick={handleSignOut}
                    >
                      Logout
                    </li>
                  </ul>
                </div>
              )}
            </li>
          )}
          <li>EN</li>
        </ul>
      </div>
    </div>
  );
};

export default Header1;