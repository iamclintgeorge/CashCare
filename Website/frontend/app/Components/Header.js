import React from "react";
import Link from "next/link";

const Header = () => {
  return (
    <>
    <div className="bg-gray-200 bg-opacity-85 backdrop-blur-md sticky top-0  z-50 pt-5 pb-3 transition-all duration-300">
      <div className="flex justify-around">
        <div className="font-extrabold tracking-widest text-lg leading-5">
          {/* <p>CASH</p>
          <p>CARE</p> */}
            <Link href="/" passHref>
              <p>CASH</p>
              <p>CARE</p>
          </Link>
        </div>
        <ul className="flex gap-10 items-center text-sm tracking-widest">
          <li>HOME</li>
          <li><a href="/Pricing">PRICING</a></li>
          <li>PRODUCTS</li>
          <li>RESOURCES</li>
          <li>CONTACT US</li>
        </ul>
        <ul className="flex gap-5 items-center text-xs tracking-widest">
          <li className="border rounded-2xl px-5 py-2 border-black">
            <Link href="/Signup">SIGN IN</Link>
          </li>
          <li>EN</li>
        </ul>
      </div>
      </div>
    </>
  );
};

export default Header;
