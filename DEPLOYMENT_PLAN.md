# School Management System - Deployment Plan

## 📋 Executive Summary

This deployment plan outlines the complete process for deploying:
- **Backend**: Django REST API → Render (with PostgreSQL database)
- **Frontend**: React Application → Vercel

---

## 🔍 Backend Analysis Summary

### Technology Stack
- **Framework**: Django 5.2.7
- **Database**: Currently MySQL (needs migration to PostgreSQL for Render)
- **Python Version**: 3.13
- **Key Dependencies**:
  - Django REST Framework (3.16.1)
  - Django CORS Headers (4.9.0)
  - djangorestframework-simplejwt (5.5.1)
  - drf-yasg (1.21.11) - API documentation
  - Pillow (12.0.0) - Image handling

### Current Configuration
- **Project Name**: Swostitech_Acadix
- **Current DB**: MySQL at 31.97.63.174
- **CORS**: Configured (allows all origins - needs security hardening)
- **JWT Authentication**: Configured with 24-hour token lifetime
- **Media Files**: Stored in `SWOSTITECH_CMS/` directory
- **Apps**: 16 custom Django apps (Acadix, Transport, Library, EXPENSE, HOSTEL, etc.)

### Issues Identified
⚠️ **Critical Issues** (from PROJECT_ISSUES_SUMMARY.md):
- API endpoint inconsistencies
- Serializer field naming mismatches
- View logic errors
- Code quality issues

These will need addressing but won't block initial deployment.

---

## 📦 Deployment Strategy

### Phase 1: Backend Deployment to Render
1. Database migration (MySQL → PostgreSQL)
2. Production configuration updates
3. Static/Media file handling setup
4. Environment variables configuration
5. Deployment files creation
6. Render deployment

### Phase 2: Frontend Deployment to Vercel
1. API URL configuration
2. Environment setup
3. Build optimization
4. Vercel deployment
5. Integration testing

---

## 🗃️ Phase 1: Backend Deployment (Render)

### Step 1: Database Setup on Render
**Action**: Create PostgreSQL database on Render
- Database will provide:
  - `POSTGRES_HOST`
  - `POSTGRES_DB`
  - `POSTGRES_USER`
  - `POSTGRES_PASSWORD`
  - `DATABASE_URL` (full connection string)

### Step 2: Required Backend Changes

#### 2.1 Update requirements.txt
**Add**:
```txt
psycopg2-binary==2.9.9
gunicorn==21.2.0
whitenoise==6.6.0
python-dotenv==1.0.0
dj-database-url==2.1.0
```

**Purpose**:
- `psycopg2-binary`: PostgreSQL adapter
- `gunicorn`: Production WSGI server
- `whitenoise`: Static file serving
- `python-dotenv`: Environment variable management
- `dj-database-url`: Database URL parsing

#### 2.2 Update settings.py
**Changes needed**:
1. Import required modules
2. Update `DEBUG` setting for production
3. Configure `ALLOWED_HOSTS` with Render domain
4. Update database configuration for PostgreSQL
5. Configure static files with WhiteNoise
6. Secure CORS settings
7. Add security settings for production

#### 2.3 Create Deployment Files
1. **render.yaml** - Render blueprint configuration
2. **build.sh** - Build script for migrations and static collection
3. **.env.example** - Template for environment variables
4. **Procfile** - Optional process definition

### Step 3: Environment Variables on Render
```
SECRET_KEY=<generate-new-secret-key>
DEBUG=False
DATABASE_URL=<render-postgresql-url>
ALLOWED_HOSTS=<your-render-app>.onrender.com,localhost
CORS_ALLOWED_ORIGINS=https://<your-vercel-app>.vercel.app

# Email Configuration
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=info.swostibbsr@gmail.com
EMAIL_HOST_PASSWORD=rwlqodsnjchmbwxa
DEFAULT_FROM_EMAIL=info.swostibbsr@gmail.com
```

### Step 4: Static & Media Files Strategy
**Options**:
1. **Option A** (Recommended): Use AWS S3 or Cloudinary for media files
2. **Option B**: Use Render's disk storage (limited, not persistent)
3. **Option C**: WhiteNoise for static, separate CDN for media

**For initial deployment**: WhiteNoise + local storage (with caveat about persistence)

---

## 🎨 Phase 2: Frontend Deployment (Vercel)

### Step 1: Update API Configuration
**File**: `src/ApiUrl.jsx`
```jsx
export const ApiUrl = {
  apiurl: process.env.REACT_APP_API_URL || "http://localhost:8000/api/",
};
```

### Step 2: Environment Variables on Vercel
```
REACT_APP_API_URL=https://<your-render-app>.onrender.com/api/
```

### Step 3: Create vercel.json
**Purpose**: Configure routing for React SPA
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/" }
  ]
}
```

### Step 4: Update package.json (if needed)
- Already has build script configured
- Memory allocation set to 4GB (good for build)

---

## 🔐 Security Considerations

### Immediate (Pre-deployment):
1. ✅ Generate new SECRET_KEY for production
2. ✅ Set DEBUG=False
3. ✅ Configure specific ALLOWED_HOSTS
4. ✅ Restrict CORS_ALLOWED_ORIGINS to Vercel domain
5. ✅ Use strong database password

### Post-deployment:
1. 📝 Implement rate limiting
2. 📝 Add HTTPS enforcement
3. 📝 Configure CSP headers
4. 📝 Review JWT token lifetimes
5. 📝 Audit API endpoint security

---

## 📊 Migration Checklist

### Database Migration (MySQL → PostgreSQL)
⚠️ **Data Loss Warning**: This setup creates a fresh database

**Options**:
1. **Fresh Start**: New database (easiest for deployment)
2. **Data Migration**: Export MySQL → Import PostgreSQL (requires manual work)

**If migrating data**:
```bash
# Export from MySQL
python manage.py dumpdata --natural-foreign --natural-primary > data.json

# After PostgreSQL setup
python manage.py migrate
python manage.py loaddata data.json
```

---

## 🚀 Deployment Steps Summary

### Backend (Render):
1. ✅ Create Render PostgreSQL database
2. ✅ Update backend configuration files
3. ✅ Create render.yaml and build.sh
4. ✅ Push to GitHub (or connect repo)
5. ✅ Create Web Service on Render
6. ✅ Configure environment variables
7. ✅ Deploy and test

### Frontend (Vercel):
1. ✅ Update API URL configuration
2. ✅ Create vercel.json
3. ✅ Connect GitHub repo to Vercel
4. ✅ Configure environment variables
5. ✅ Deploy and test
6. ✅ Update CORS settings on backend with Vercel URL

---

## 🧪 Testing Strategy

### Backend Testing:
1. Health check endpoint
2. Admin panel access
3. API authentication (JWT)
4. File upload functionality
5. Database operations

### Frontend Testing:
1. API connectivity
2. Authentication flow
3. Core functionality (CRUD operations)
4. File uploads/downloads
5. Cross-browser testing

---

## 📌 Known Issues & Limitations

### Technical Debt:
- API endpoint inconsistencies (documented in PROJECT_ISSUES_SUMMARY.md)
- Field naming mismatches between frontend/backend
- Code quality issues in views/serializers

### Deployment Limitations:
- Render free tier: App spins down after inactivity (causes 50s cold start)
- Media files on Render: Not persistent across deploys (consider cloud storage)
- Database size limits on free tier

---

## 🔄 Post-Deployment Tasks

### Immediate:
1. Test all critical API endpoints
2. Verify file upload/download functionality
3. Check email functionality
4. Monitor error logs
5. Set up uptime monitoring

### Short-term:
1. Implement proper media storage (S3/Cloudinary)
2. Add error tracking (Sentry)
3. Set up automated backups
4. Performance optimization
5. Address technical debt items

---

## 📞 Support & Rollback Plan

### Rollback Strategy:
1. Keep current MySQL database running during initial deployment
2. Document all environment variables
3. Maintain local development environment
4. Git tag stable releases

### Monitoring:
- Render Dashboard: Application logs and metrics
- Vercel Dashboard: Deployment logs and analytics
- Database metrics through Render

---

## 💰 Cost Estimation

### Free Tier (Development/Testing):
- **Render**: Free PostgreSQL (90 days), Free web service (512MB RAM)
- **Vercel**: Free tier (hobby projects)
- **Total**: $0/month

### Production (Recommended):
- **Render**: Starter PostgreSQL ($7/mo) + Starter Web Service ($7/mo)
- **Vercel**: Pro tier ($20/mo) for better performance
- **Cloud Storage**: AWS S3 (~$5-10/mo) or Cloudinary free tier
- **Total**: ~$19-44/month

---

## ✅ Next Steps

**Ready to proceed with**:
1. Create all necessary configuration files
2. Set up Render database
3. Deploy backend to Render
4. Deploy frontend to Vercel
5. Integration testing

**Should we begin implementation?**
