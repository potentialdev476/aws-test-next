'use client';

import React, { createContext, useContext, useEffect, useState } from 'react';
import Cookies from 'js-cookie';
import { authAPI } from '@/lib/api';

interface User {
  id: number;
  name: string;
  email: string;
  created_at: string;
  updated_at: string;
}

interface AuthContextType {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (name: string, email: string, password: string, passwordConfirmation: string) => Promise<void>;
  logout: () => Promise<void>;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: React.ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  // Initialize auth state from cookies
  useEffect(() => {
    const initializeAuth = async () => {
      const savedToken = Cookies.get('auth_token');
      const savedUser = Cookies.get('user');

      if (savedToken && savedUser) {
        try {
          setToken(savedToken);
          setUser(JSON.parse(savedUser));

          // Verify token is still valid
          await authAPI.getMe();
        } catch (error) {
          // Token is invalid, clear cookies
          Cookies.remove('auth_token');
          Cookies.remove('user');
          setToken(null);
          setUser(null);
        }
      }
      setIsLoading(false);
    };

    initializeAuth();
  }, []);

  const login = async (email: string, password: string) => {
    try {
      const response = await authAPI.login({ email, password });

      if (response.success) {
        const { user: userData, token: authToken } = response.data;

        // Save to cookies
        Cookies.set('auth_token', authToken, { expires: 7 }); // 7 days
        Cookies.set('user', JSON.stringify(userData), { expires: 7 });

        // Update state
        setUser(userData);
        setToken(authToken);
      } else {
        throw new Error(response.message || 'Login failed');
      }
    } catch (error: any) {
      throw new Error(error.response?.data?.message || 'Login failed');
    }
  };

  const register = async (name: string, email: string, password: string, passwordConfirmation: string) => {
    try {
      const response = await authAPI.register({
        name,
        email,
        password,
        password_confirmation: passwordConfirmation,
      });

      if (response.success) {
        const { user: userData, token: authToken } = response.data;

        // Save to cookies
        Cookies.set('auth_token', authToken, { expires: 7 }); // 7 days
        Cookies.set('user', JSON.stringify(userData), { expires: 7 });

        // Update state
        setUser(userData);
        setToken(authToken);
      } else {
        throw new Error(response.message || 'Registration failed');
      }
    } catch (error: any) {
      throw new Error(error.response?.data?.message || 'Registration failed');
    }
  };

  const logout = async () => {
    try {
      await authAPI.logout();
    } catch (error) {
      // Even if logout fails on server, clear local state
      console.error('Logout error:', error);
    } finally {
      // Clear cookies and state
      Cookies.remove('auth_token');
      Cookies.remove('user');
      setUser(null);
      setToken(null);
    }
  };

  const value: AuthContextType = {
    user,
    token,
    isLoading,
    login,
    register,
    logout,
    isAuthenticated: !!user && !!token,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
