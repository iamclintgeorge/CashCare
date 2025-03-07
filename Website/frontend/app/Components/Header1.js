// import React, { useState, useEffect } from "react";
// import Link from "next/link";

// const Header1 = () => {
//   const [user, setUser] = useState(null);
//   const [menuVisible, setMenuVisible] = useState(false);

//   useEffect(() => {
//     const fetchUserData = async () => {
//       const userData = await getUserDataFromDatabase();
//       setUser(userData);
//     };

//     fetchUserData();
//   }, []);

//   const getUserDataFromDatabase = () => {
//     return new Promise((resolve) => {
//       setTimeout(() => {
//         resolve({ name: "Lily" });
//       }, 1000);
//     });
//   };

//   const toggleMenu = () => {
//     setMenuVisible(!menuVisible);
//   };

//   const signOut = () => {
//     // Add sign-out logic here
//     setUser(null);
//   };

//   return (
//     <div className="bg-gray-200 bg-opacity-85 backdrop-blur-md sticky top-0 z-50 pt-5 pb-3 transition-all duration-300">
//       <div className="flex justify-around">
//         <div className="font-extrabold tracking-widest text-lg leading-5">
//           <Link href="/" passHref>
//             <p>CASH</p>
//             <p>CARE</p>
//           </Link>
//         </div>
//         <ul className="flex gap-10 items-center text-sm tracking-widest">
//           <li><Link href="/">HOME</Link></li>
//           <li><Link href="/Pricing">PRICING</Link></li>
//           <li>PRODUCTS</li>
//           <li>RESOURCES</li>
//           <li>CONTACT US</li>
//         </ul>
//         <ul className="flex gap-5 items-center text-xs tracking-widest">
//           {!user ? (
//             <li className="border rounded-2xl px-5 py-2 border-black">
//               <Link href="/Signup">SIGN IN</Link>
//             </li>
//           ) : (
//             <li className="relative">
//               <div
//                 onClick={toggleMenu}
//                 className="w-8 h-8 bg-gray-800 text-white flex items-center justify-center rounded-full cursor-pointer"
//               >
//                 {user.name[0].toUpperCase()}
//               </div>
//               {menuVisible && (
//                 <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg p-2">
//                   <p className="text-gray-700">Welcome, {user.name}!</p>
//                   <ul className="mt-2">
//                     <li className="py-1 hover:bg-gray-100 cursor-pointer">
//                       <Link href="/ManageAccount">Manage Account</Link>
//                     </li>
//                     <li
//                       className="py-1 hover:bg-gray-100 cursor-pointer"
//                       onClick={signOut}
//                     >
//                       Sign Out
//                     </li>
//                   </ul>
//                 </div>
//               )}
//             </li>
//           )}
//           <li>EN</li>
//         </ul>
//       </div>
//     </div>
//   );
// };

// export default Header1;

















import React, { useState, useEffect } from "react";
import Link from "next/link";

const Header1 = () => {
  const [user, setUser] = useState(null);
  const [menuVisible, setMenuVisible] = useState(false);

  useEffect(() => {
    const fetchUserData = async () => {
      const userId = 1; // Replace with the actual user ID, maybe from localStorage or a session
      const response = await fetch(`/api/user?id=${userId}`);

      if (response.ok) {
        const data = await response.json();
        setUser(data); // Set the user data (name)
      } else {
        console.error("Failed to fetch user data");
      }
    };

    fetchUserData();
  }, []);

  const toggleMenu = () => {
    setMenuVisible(!menuVisible);
  };

  const signOut = () => {
    // Remove user data from localStorage and sign out
    localStorage.removeItem("user");
    setUser(null);
  };

  return (
    <div className="bg-gray-200 bg-opacity-85 backdrop-blur-md sticky top-0 z-50 pt-5 pb-3 transition-all duration-300">
      <div className="flex justify-around">
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
            <li className="border rounded-2xl px-5 py-2 border-black">
              <Link href="/Signup">SIGN IN</Link>
            </li>
          ) : (
            <li className="relative">
              <div
                onClick={toggleMenu}
                className="w-8 h-8 bg-gray-800 text-white flex items-center justify-center rounded-full cursor-pointer"
              >
                {user.name ? user.name[0].toUpperCase() : "?"}
              </div>
              {menuVisible && (
                <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg p-2">
                  <p className="text-gray-700">Welcome, {user.name}!</p>
                  <ul className="mt-2">
                    <li className="py-1 hover:bg-gray-100 cursor-pointer">
                      <Link href="/ManageAccount">Manage Account</Link>
                    </li>
                    <li
                      className="py-1 hover:bg-gray-100 cursor-pointer"
                      onClick={signOut}
                    >
                      Sign Out
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







