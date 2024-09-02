import React from "react";

const Header = () => {
  return (
    <>
      <div className="mt-10 flex justify-around">
        <div className="font-extrabold tracking-widest text-lg leading-5">
          <p>CASH</p>
          <p>CARE</p>
        </div>
        <ul className="flex gap-10 items-center text-sm tracking-widest">
          <li>HOME</li>
          <li>PRICING</li>
          <li>PRODUCTS</li>
          <li>RESOURCES</li>
          <li>CONTACT US</li>
        </ul>
        <ul className="flex gap-5 items-center text-xs tracking-widest">
          <li className="border rounded-2xl px-5 py-2 border-black">SIGN IN</li>
          <li>EN</li>
        </ul>
      </div>
    </>
  );
};

export default Header;
