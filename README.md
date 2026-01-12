# School Management System (SMS)

Full-stack school management application with Django REST API backend and React frontend, ready for deployment on Render and Vercel.

## 🏗️ Project Structure

```
SMS_Render/
├── SchoolManagementBackend/     # Django REST API Backend
│   └── CollegeManagement/
│       ├── manage.py
│       ├── requirements.txt
│       ├── build.sh             # Render build script
│       ├── render.yaml          # Render configuration
│       └── Swostitech_Acadix/   # Main Django project
│
├── schoolmanagement_FrontEnd/   # React Frontend
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── vercel.json              # Vercel configuration
│
└── Documentation/
    ├── DEPLOYMENT_PLAN.md
    ├── RENDER_DEPLOYMENT_GUIDE.md
    ├── VERCEL_DEPLOYMENT_GUIDE.md
    └── QUICK_DEPLOY_CHECKLIST.md
```

## 🚀 Quick Start

### Backend (Django)

```bash
cd SchoolManagementBackend/CollegeManagement

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run development server
python manage.py runserver
```

### Frontend (React)

```bash
cd schoolmanagement_FrontEnd

# Install dependencies
npm install

# Set up environment
cp .env.example .env.local
# Edit .env.local with your API URL

# Run development server
npm start
```

## 📦 Tech Stack

### Backend
- **Framework**: Django 5.2.7
- **API**: Django REST Framework 3.16.1
- **Authentication**: JWT (djangorestframework-simplejwt)
- **Database**: PostgreSQL (Production) / MySQL (Development)
- **API Documentation**: drf-yasg (Swagger)
- **Python**: 3.13

### Frontend
- **Framework**: React 18.3.1
- **UI Libraries**: Material-UI, React Bootstrap
- **Charts**: Chart.js, Recharts
- **HTTP Client**: Axios
- **Routing**: React Router DOM
- **Icons**: FontAwesome, Lucide React

## 🌐 Deployment

### Render (Backend)

1. **Database**: PostgreSQL on Render
2. **Web Service**: Python 3 environment
3. **Environment Variables**: See `.env.example`
4. **Build Command**: `./build.sh`
5. **Start Command**: `gunicorn Swostitech_Acadix.wsgi:application`

📖 **Guide**: [RENDER_DEPLOYMENT_GUIDE.md](RENDER_DEPLOYMENT_GUIDE.md)

### Vercel (Frontend)

1. **Framework**: Create React App
2. **Build Command**: `npm run build`
3. **Output Directory**: `build`
4. **Environment Variable**: `REACT_APP_API_URL`

📖 **Guide**: [VERCEL_DEPLOYMENT_GUIDE.md](VERCEL_DEPLOYMENT_GUIDE.md)

### Quick Deploy (30 minutes)

📋 **Follow**: [QUICK_DEPLOY_CHECKLIST.md](QUICK_DEPLOY_CHECKLIST.md)

## 🔑 Environment Variables

### Backend (.env)

```env
SECRET_KEY=your-secret-key
DEBUG=False
ALLOWED_HOSTS=your-app.onrender.com
DATABASE_URL=postgresql://user:pass@host:port/dbname
CORS_ALLOWED_ORIGINS=https://your-frontend.vercel.app
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
```

### Frontend (.env.local)

```env
REACT_APP_API_URL=https://your-backend.onrender.com/api/
```

## 🏫 Features

### Admin Features
- Organization & Branch Management
- Academic Year & Terms Setup
- User Management (Staff, Students)
- Course & Batch Management
- Fee Management
- Attendance Tracking
- Report Card Generation
- Time Table Management

### Staff Features
- Student Information Management
- Attendance Marking
- Grade Entry
- Report Generation
- Library Management
- Transport Management

### Student Features
- View Personal Information
- Check Attendance
- View Grades & Report Cards
- Library Book Status
- Fee Payment History
- Time Table Access

### Additional Modules
- **Library Management**: Book inventory, issue/return tracking
- **Transport Management**: Route, vehicle, and student transport tracking
- **Hostel Management**: Room allocation, attendance
- **Expense Management**: Financial tracking
- **Grievance System**: Complaint management
- **Training & Placement**: Campus recruitment tracking
- **Visitor Management**: Gate pass system
- **Inventory Management**: Asset tracking
- **MOU Management**: Agreement tracking

## 📊 Database Schema

The system uses 16 Django apps with comprehensive models for:
- User management and authentication
- Academic structure (courses, batches, subjects)
- Student and staff information
- Attendance and grades
- Financial transactions
- Supporting modules (library, transport, hostel, etc.)

## 🔐 Security Features

- JWT token-based authentication
- Role-based access control
- CORS protection
- HTTPS enforcement (production)
- Secure cookie handling
- XSS protection headers
- CSRF protection

## 🧪 API Documentation

Once deployed, access Swagger documentation at:
```
https://your-backend.onrender.com/swagger/
```

## 📝 Development

### Running Tests

```bash
# Backend
cd SchoolManagementBackend/CollegeManagement
python manage.py test

# Frontend
cd schoolmanagement_FrontEnd
npm test
```

### Code Structure

**Backend Apps**:
- `Acadix`: Core academic management
- `STAFF`: Staff management
- `Transport`: Transport system
- `Library`: Library management
- `EXPENSE`: Financial tracking
- `HOSTEL`: Hostel management
- `MOU`: MOU tracking
- `TRAINING_PLACEMENT`: Placement management
- `ACADEMIC_DOCUMENTS`: Document management
- `GRIEVANCE`: Grievance handling
- `MENTOR`: Mentorship system
- `TIME_TABLE`: Scheduling
- `VISITORS`: Visitor management
- `DASHBOARD_APP`: Analytics dashboard
- `REPORT_CARD`: Report generation
- `INVENTORY`: Asset management

## 🐛 Known Issues

See [PROJECT_ISSUES_SUMMARY.md](SchoolManagementBackend/PROJECT_ISSUES_SUMMARY.md) for technical debt and known issues.

## 💰 Hosting Costs

### Free Tier
- Render PostgreSQL: $0 (90 days) → $7/month
- Render Web Service: $0 (with limitations)
- Vercel: $0
- **Total**: $0 → $7/month

### Production Tier
- Render PostgreSQL Starter: $7/month
- Render Web Service Starter: $7/month
- Vercel Pro: $20/month
- AWS S3 (media): ~$5/month
- **Total**: ~$39/month

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

- **Documentation**: Check the `Documentation/` folder
- **Issues**: GitHub Issues
- **Render Support**: https://render.com/docs
- **Vercel Support**: https://vercel.com/docs

## 📄 License

[Specify your license here]

## 👥 Authors

Swostitech Solutions

## 🔄 Version History

- **v1.0.0** (January 2026) - Initial deployment-ready version
  - Backend configured for Render
  - Frontend configured for Vercel
  - PostgreSQL database support
  - Complete documentation

---

**Ready to deploy?** Start with [QUICK_DEPLOY_CHECKLIST.md](QUICK_DEPLOY_CHECKLIST.md)
