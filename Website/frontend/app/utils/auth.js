// auth.js
export function getAuthToken() {
    return localStorage.getItem('token');
  }
  
  export async function fetchProtectedData() {
    const token = getAuthToken();
    try {
      const response = await fetch('/api/protected', {
        headers: {
          'Authorization': `Bearer ${token}`,
        },
      });
      const data = await response.json();
      console.log(data);
    } catch (error) {
      console.error('Error fetching protected data:', error);
    }
  }
  