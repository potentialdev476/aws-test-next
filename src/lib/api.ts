import axios from 'axios';
import Cookies from 'js-cookie';

const API_BASE_URL = 'http://56.228.2.161/api';

// Create axios instance
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Request interceptor to add auth token
apiClient.interceptors.request.use(
  (config) => {
    const token = Cookies.get('auth_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle token expiration
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired or invalid, clear cookies and redirect to login
      Cookies.remove('auth_token');
      Cookies.remove('user');
      if (typeof window !== 'undefined') {
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

// Auth API functions
export const authAPI = {
  // Register user
  register: async (userData: {
    name: string;
    email: string;
    password: string;
    password_confirmation: string;
  }) => {
    const response = await apiClient.post('/register', userData);
    return response.data;
  },

  // Login user
  login: async (credentials: {
    email: string;
    password: string;
  }) => {
    const response = await apiClient.post('/login', credentials);
    return response.data;
  },

  // Logout user
  logout: async () => {
    const response = await apiClient.post('/logout');
    return response.data;
  },

  // Get current user
  getMe: async () => {
    const response = await apiClient.get('/me');
    return response.data;
  },
};

export default apiClient;
