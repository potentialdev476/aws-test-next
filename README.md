# Next.js Authentication Frontend

A modern, responsive authentication frontend built with Next.js 15, TypeScript, and Tailwind CSS that integrates with the Laravel authentication API.

## Features

- **Modern UI/UX**: Clean, responsive design with Tailwind CSS
- **TypeScript**: Full type safety throughout the application
- **Authentication**: Complete login/register system with token management
- **Protected Routes**: Automatic redirection based on authentication status
- **Cookie Management**: Secure token storage with js-cookie
- **API Integration**: Seamless communication with Laravel backend

## Tech Stack

- **Next.js 15** - React framework with App Router
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client for API requests
- **js-cookie** - Cookie management
- **React Context** - State management for authentication

## Getting Started

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start the development server:**
   ```bash
   npm run dev
   ```

3. **Open your browser:**
   Navigate to [http://localhost:3000](http://localhost:3000)

## Project Structure

```
src/
├── app/                    # Next.js App Router pages
│   ├── dashboard/         # Protected dashboard page
│   ├── login/             # Login page
│   ├── register/          # Registration page
│   ├── layout.tsx         # Root layout with AuthProvider
│   └── page.tsx           # Home page
├── contexts/              # React contexts
│   └── AuthContext.tsx    # Authentication context
└── lib/                   # Utility libraries
    └── api.ts             # API client and auth functions
```

## Authentication Flow

1. **Registration**: Users can create new accounts
2. **Login**: Existing users can sign in
3. **Token Management**: JWT tokens are stored in HTTP-only cookies
4. **Protected Routes**: Dashboard requires authentication
5. **Auto-redirect**: Users are redirected based on auth status
6. **Logout**: Secure logout with token cleanup

## API Integration

The frontend communicates with the Laravel backend at `http://localhost:8000/api`:

- **POST** `/register` - User registration
- **POST** `/login` - User login
- **POST** `/logout` - User logout
- **GET** `/me` - Get current user

## Environment Setup

Make sure your Laravel backend is running on `http://localhost:8000` before starting the frontend.

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

## Features Overview

### Home Page (`/`)
- Landing page with feature highlights
- Automatic redirect to dashboard if authenticated
- Links to login and register pages

### Login Page (`/login`)
- Email and password authentication
- Form validation and error handling
- Link to registration page

### Register Page (`/register`)
- User registration with name, email, and password
- Password confirmation validation
- Link to login page

### Dashboard Page (`/dashboard`)
- Protected route requiring authentication
- User information display
- Logout functionality
- Quick action buttons

## Authentication Context

The `AuthContext` provides:
- User state management
- Authentication status
- Login/logout functions
- Token management
- Loading states

## API Client

The API client (`lib/api.ts`) handles:
- HTTP requests to Laravel backend
- Automatic token attachment
- Error handling and token expiration
- Response interceptors

## Styling

The application uses Tailwind CSS for styling with:
- Responsive design
- Modern UI components
- Consistent color scheme
- Accessibility features

## Security Features

- Token-based authentication
- Secure cookie storage
- Automatic token refresh
- Protected route handling
- CSRF protection (handled by Laravel)

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Development Notes

- The app uses Next.js App Router (not Pages Router)
- All components are client-side rendered (`'use client'`)
- TypeScript strict mode is enabled
- ESLint configuration follows Next.js recommendations