"use client";
import React from "react";
import { useRouter } from "next/navigation";

const Herosec = () => {
  const router = useRouter();

  return (
    <>
      <div className="place-content-center text-center bg-gray-200">
        <main className="flex flex-col items-center justify-center h-screen text-center ">
          <h2 className="text-6xl font-bold mb-5">
            <span className="text-black">
              Protect Your Network <br></br>with
            </span>{" "}
            <span className="text-orange-800">CashCare</span>
          </h2>
          <p className="mt-4 mb-5 text-base text-black">
            Real-time protection from fake banking sites, phishing IPs, and
            suspicious traffic. <br />
            Stay one step ahead of cyber threats—automatically and effortlessly.
          </p>
          <a href="/appCashCare" download>
            <div className="mt-5 pl-8 pr-6 py-2 bg-black text-white rounded-full flex items-center justify-center">
              <span>Download</span>
              <span className="ml-4 text-white">&#8595;</span>
            </div>
          </a>
        </main>
      </div>
    </>
  );
};

export default Herosec;
