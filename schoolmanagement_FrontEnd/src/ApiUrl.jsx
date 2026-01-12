// API URL Configuration
// Uses environment variable in production, falls back to development URL
export const ApiUrl = {
  apiurl: process.env.REACT_APP_API_URL || "http://127.0.0.1:8000/api/",
};

// Development URLs (for reference)
// Local: http://127.0.0.1:8000/api/
// Remote Dev: http://31.97.63.174:9000/api/
// Production: Set via REACT_APP_API_URL environment variable

