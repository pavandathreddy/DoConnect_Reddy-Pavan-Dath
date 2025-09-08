# DoConnect - Q&A Platform

A modern, feature-rich question and answer platform built with **ASP.NET Core** and **React**, designed to foster community learning and knowledge sharing.

![DoConnect Banner](https://via.placeholder.com/800x200/4f46e5/ffffff?text=DoConnect+-+Connect.+Ask.+Learn.)

---

## 🌟 Features

### Core Functionality
- **User Authentication & Authorization**
  - JWT-based authentication
  - Email verification
  - Password reset functionality
  - Admin and moderator roles

- **Question & Answer System**
  - Rich text editor for questions and answers
  - File attachments (images, documents)
  - Voting system (upvote/downvote)
  - Answer acceptance
  - Question categorization and tagging

- **Community Features**
  - User profiles with reputation system
  - Bookmarking questions
  - Real-time notifications
  - Commenting on questions and answers
  - Search functionality

- **Admin Panel**
  - Content moderation (approve/reject questions and answers)
  - User management
  - Analytics dashboard
  - Audit logging

### Technical Features
- **Modern Architecture**: Clean Architecture, Repository & Unit of Work, CQRS with MediatR
- **Security**: JWT authentication, XSS & CSRF protection, input validation
- **Performance**: Database indexing, Redis caching, pagination, image optimization, lazy loading

---

## 🛠️ Technology Stack

**Backend**: ASP.NET Core 7.0, SQL Server, Entity Framework Core, JWT Authentication, Swagger/OpenAPI  
**Frontend**: React 18, Context API/Redux, Tailwind CSS, Axios, React Hook Form, React Quill  
**DevOps & Tools**: Docker, GitHub Actions, SonarQube, npm/yarn, NuGet

---

## 📋 Prerequisites

- [.NET 7.0 SDK](https://dotnet.microsoft.com/download/dotnet/7.0)  
- [Node.js](https://nodejs.org/) (v16+)  
- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)  
- [Git](https://git-scm.com/)

---

## 🚀 Getting Started

### Clone the Repository
```bash
git clone https://github.com/pavandathreddy/DoConnect_Reddy-Pavan-Dath.git
cd DoConnect_Reddy-Pavan-Dath

--Database Setup

# Open SQL Server and execute the schema script
sqlcmd -S localhost -d DoConnect -i Database_Schema_DoConnect.sql

Backend Setup

cd backend
dotnet restore
dotnet run

Frontend Setup
cd frontend
npm install
npm start

Frontend: http://localhost:3000

Backend API: https://localhost:5291 (or configured port)

📁 Project Structure
DoConnect/
├── backend/          # ASP.NET Core API
├── frontend/         # React frontend
├── screenshots/      # Project screenshots
├── Database_Schema_DoConnect.sql
├── DoConnect.sln
├── Final_Report_REDDY-PAVAN-DATH.pdf
└── README.md

🔐 Default User Accounts
Role	Email	Password
Admin	admin@doconnect.com
	password123
User	john.doe@email.com
	password123
User	sarah.miller@email.com
	password123

Note: Change these passwords in production.

📝 API Endpoints

Authentication

POST /api/auth/register

POST /api/auth/login

POST /api/auth/forgot-password

###Questions

GET /api/questions

POST /api/questions

GET /api/questions/{id}

###Answers

GET /api/questions/{id}/answers

POST /api/questions/{id}/answers

POST /api/answers/{id}/accept


###Admin

GET /api/admin/pending-questions

POST /api/admin/questions/{id}/approve

.
.
.
.
.

Built with ❤️ by Pavan Reddy
