import React from "react";

const Whycashcare = () => {
  return (
    <>
      <div className="bg-black">
        <div className="flex flex-col">
          <h1 className="text-white text-6xl font-semibold pl-9 pt-14">WHY</h1>
          <h1 className="text-white text-6xl italic pl-9">CASHCARE?</h1>
        </div>
        <div className="mt-10 w-full flex justify-end">
          <p className="text-white ml-[50vw] pr-9 text-justify">
            CashCare is your first line of defense against cyber threats
            targeting your financial safety. In an age where phishing scams and
            fraudulent banking redirects are on the rise, CashCare actively
            monitors your device’s internet traffic to detect suspicious
            connections—before they cause damage. Our mission is simple: make
            cybersecurity accessible, automatic, and effective for everyone.
          </p>
        </div>
        <div className="mt-16 w-full">
          <h1 className="text-white text-4xl italic pl-9">SECURE.</h1>
          <p className="text-white mt-6 pl-9 mr-[50vw] text-justify">
            Your financial data is a prime target for hackers. CashCare uses
            real-time monitoring to alert you when your device connects to known
            malicious or unverified IP addresses that are commonly associated
            with phishing, spyware, or fraudulent banking sites. No complicated
            setup—just protection that works from the moment you start the app.
          </p>
        </div>
        <h1 className="text-white text-4xl italic flex justify-end pr-[26vw] mr-52 mt-16">
          FAST.
        </h1>
        <div className="mt-2 flex justify-end">
          <p className="text-white mt-5 ml-[50vw] pr-9 text-justify">
            Time is critical when dealing with online threats. CashCare is
            designed to detect suspicious behavior within seconds, not hours.
            Get immediate alerts about potential risks so you can act before
            damage is done. Whether you’re banking online, accessing emails, or
            browsing news—CashCare is always watching in the background.
          </p>
        </div>
        <div className="mt-16 w-full">
          <h1 className="text-white text-4xl italic pl-9">RELIABLE.</h1>
          <p className="text-white mt-6 pl-9 mr-[50vw] text-justify">
            Built for individuals and small businesses, CashCare runs
            efficiently on most devices with minimal resource usage. No bloat,
            no noise—just clear, actionable alerts when it matters most. Backed
            by a growing threat database, CashCare is continuously improving to
            keep up with the latest attack trends.
          </p>
        </div>
        <div>
          <div className="flex justify-end pb-14">
            <button className="mt-8 px-7 py-3 bg-black text-white rounded-full flex items-center justify-center border-2 border-white mr-9">
              <a href="/appCashCare" download>
                <span className="font-bold">Download</span>
                <span className="ml-2 text-white">&#8595;</span>
              </a>
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Whycashcare;
