import React from 'react'
  
const Herosec = () => {
  return (
    <>
      {/* <div>Hello Welcome to Hero Section</div> */}
      {/* for styling directly size={60} */}
      <div className="place-content-center text-center">
      <main className="flex flex-col items-center justify-center h-screen text-center ">
        <h2 className="text-6xl font-bold">
          <span className="text-black">Find clients who <br></br>just raised</span> <span className="text-orange-800">Venture Capital</span>
        </h2>
        <p className="mt-4 text-base text-black">
          Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit. Vestibulum Ac Ultricies Libero,<br></br> Vitae Commodo Dolor. Sed Fermentum Semper Ex A Varius.
        </p>
        {/* <button className="mt-5 px-4 py-2 bg-gray-800 text-white rounded">
          <a href="/get-started">GET STARTED</a>
        </button> */}
        <button className="mt-5 px-7 py-3 bg-black text-white rounded-full flex items-center justify-center">
            <span className="font-bold">GET STARTED</span>
            <span className="ml-2">→</span>
          </button>
      </main>
    </div>
    </>
  )
}

export default Herosec