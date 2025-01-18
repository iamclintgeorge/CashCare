// app/Dashboard/PrivateRoute.js
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';

const PrivateRoute = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const router = useRouter();

  useEffect(() => {
    const token = document.cookie.split(';').find(cookie => cookie.trim().startsWith('token='));

    if (token) {
      setIsAuthenticated(true);
    } else {
      router.push('/login'); // Redirect to login if not authenticated
    }
  }, []);

  if (!isAuthenticated) {
    return <div>Loading...</div>;  // Show a loading spinner or message while checking
  }

  return <>{children}</>; // Render children (protected content) if authenticated
};

export default PrivateRoute;
