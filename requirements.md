# Airbnb Clone - Backend Requirements Specification

## 1. User Authentication & Management System

### Functional Requirements

#### 1.1 User Registration
- **AUTH-001**: Users can register with email, password, and basic profile information
- **AUTH-002**: Users must select role (guest/host) during registration
- **AUTH-003**: Email verification required before account activation
- **AUTH-004**: Password must meet complexity requirements

#### 1.2 User Login
- **AUTH-005**: JWT-based authentication system
- **AUTH-006**: Support for email/password login
- **AUTH-007**: Session management with refresh tokens
- **AUTH-008**: Rate limiting on login attempts

#### 1.3 Profile Management
- **AUTH-009**: Users can update personal information
- **AUTH-010**: Profile photo upload and management
- **AUTH-011**: Password reset functionality

### Technical Specifications

#### API Endpoints
```http
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/logout
POST /api/v1/auth/refresh-token
POST /api/v1/auth/forgot-password
POST /api/v1/auth/reset-password
GET  /api/v1/users/me
PUT  /api/v1/users/me
POST /api/v1/users/me/avatar
