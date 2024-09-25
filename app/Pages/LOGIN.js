import Head from 'next/head';

function IndexPage() {
  return (
    <>
      <div className="container">
        <h1 id="signup">Sign Up</h1>
        <form action="/signup" method="POST">

          <div className="b input-group">
            <input className="input" type="text" id="first_name" name="first_name" required />
            <label htmlFor="first_name" className="placeholder">First Name</label>
          </div>

          <div className="b input-group">
            <input className="input" type="text" id="last_name" name="last_name" required />
            <label htmlFor="last_name" className="placeholder">Last Name</label>
          </div>

          <div className="b input-group">
            <input className="input" type="email" id="email_signup" name="email_signup" required />
            <label htmlFor="email_signup" className="placeholder">Email</label>
          </div>

          <div className="b input-group">
            <input className="input" type="tel" id="phone" name="phone" pattern="[0-9]{10}" required />
            <label htmlFor="phone" className="placeholder">Phone No.</label>
          </div>

          <div className="b input-group">
            <input className="input" type="password" id="password_signup" name="password_signup" required />
            <label htmlFor="password_signup" className="placeholder">Password</label>
          </div>

          <input type="submit" value="Sign Up" />
        </form>

        {/* Login Form */}
        <h2>Login</h2>
        <form className="b" action="/login" method="POST">
          <div className="b input-group">
            <input className="input" type="email" id="email" name="email" required />
            <label htmlFor="email" className="placeholder">Email</label>
          </div>

          <div className="b input-group">
            <input className="input" type="password" id="password" name="password" required />
            <label htmlFor="password" className="placeholder">Password</label><br />
          </div>

          <input type="submit" value="Login" />
          <p>Forgot Unique code? <a href="#signup">Forgot</a></p>
        </form>

        <div className="toggle-con">
          <div className="toggle">
            <div className="toggle-pan toggle-left">
              <h1>WELCOME BACK</h1>
              <button className="hidden" id="login">LOGIN</button>
            </div>
          </div>
        </div>

        <div className="toggle-con">
          <div className="toggle">
            <div className="toggle-pan toggle-right">
              <h1>HELLO</h1>
              <button className="hidden" id="signup">SIGN UP</button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}

export default IndexPage;
