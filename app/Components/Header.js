import React from "react";


const Header = () => {
  return (
    <>
    <ul className="divul" >
    <li className="ul"><a href="home">HOME</a></li>
    <li className="ul"><a href="pricing">PRICING</a></li>
    <li className="ul"><a href="products" >PRODUCTS</a></li>
    <li className="ul"><a href="resources" >RESOURCES</a></li>
    <li className="ul"><a href="contact" >CONTACT US</a></li>
    <li className="ul"><button className=" button" ><a  href="sign">Sign In</a></button></li>
    </ul>
    

</>
      
    
  );
};

export default Header;
