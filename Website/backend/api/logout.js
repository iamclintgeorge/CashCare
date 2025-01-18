// api/logout.js

const express = require('express');
const router = express.Router();

router.post('/', (req, res) => {
  // Clear the token from cookies
  res.clearCookie('token', { httpOnly: true, secure: true });
  
  // Send a response to the client
  res.status(200).json({ success: true, message: 'Logged out successfully' });
});

module.exports = router;
