# School Management System - Render Deployment Guide

## 🚀 Deploying Backend to Render

### Prerequisites
1. GitHub account
2. Render account (sign up at https://render.com)
3. Your code pushed to a GitHub repository

### Step 1: Push Code to GitHub

```bash
cd d:\intern2\SchoolManagementBackend\CollegeManagement

# Initialize git if not already done
git init

# Add all files
git add .

# Commit
git commit -m "Prepare for Render deployment"

# Add remote (replace with your repo URL)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push
git push -u origin main
```

### Step 2: Create PostgreSQL Database on Render

1. Go to https://dashboard.render.com
2. Click **"New +"** → **"PostgreSQL"**
3. Configure:
   - **Name**: `schoolmanagement-db`
   - **Database**: `schoolmanagement`
   - **User**: `schoolmanagement` (auto-generated)
   - **Region**: Choose closest to your users
   - **Plan**: Free (or paid for production)
4. Click **"Create Database"**
5. **Save the connection details** (especially the Internal Database URL)

### Step 3: Create Web Service on Render

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Configure:
   - **Name**: `schoolmanagement-backend`
   - **Region**: Same as database
   - **Branch**: `main`
   - **Root Directory**: Leave empty (or set to `CollegeManagement` if deploying from root)
   - **Runtime**: `Python 3`
   - **Build Command**: `chmod +x build.sh && ./build.sh`
   - **Start Command**: `gunicorn Swostitech_Acadix.wsgi:application --bind 0.0.0.0:$PORT`

### Step 4: Configure Environment Variables

In the **Environment** section, add these variables:

```
SECRET_KEY=<generate-new-secret-key-50-chars>
DEBUG=False
ALLOWED_HOSTS=schoolmanagement-backend.onrender.com,localhost
DATABASE_URL=<paste-internal-database-url-from-step-2>
CORS_ALLOWED_ORIGINS=https://your-frontend.vercel.app
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=info.swostibbsr@gmail.com
EMAIL_HOST_PASSWORD=rwlqodsnjchmbwxa
DEFAULT_FROM_EMAIL=info.swostibbsr@gmail.com
```

**Generate SECRET_KEY** using Python:
```python
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

### Step 5: Deploy

1. Click **"Create Web Service"**
2. Wait for deployment (5-10 minutes)
3. Monitor logs for any errors

### Step 6: Verify Deployment

Once deployed, test these endpoints:

```bash
# Health check
curl https://your-app.onrender.com/api/token/

# Admin panel
https://your-app.onrender.com/admin/

# API documentation (if swagger enabled)
https://your-app.onrender.com/swagger/
```

### Step 7: Create Superuser (Admin Account)

1. Go to Render Dashboard → Your Web Service
2. Click **"Shell"** tab
3. Run:
```bash
python manage.py createsuperuser
```
4. Follow prompts to create admin account

## 🎨 Deploying Frontend to Vercel

### Step 1: Update Frontend API URL

The API URL is already configured to use environment variables in `src/ApiUrl.jsx`.

### Step 2: Deploy to Vercel

1. Go to https://vercel.com
2. Click **"Add New"** → **"Project"**
3. Import your GitHub repository (frontend)
4. Configure:
   - **Framework Preset**: Create React App
   - **Root Directory**: `schoolmanagement_FrontEnd` (if deploying from monorepo)
   - **Build Command**: `npm run build` (already configured)
   - **Output Directory**: `build`

### Step 3: Add Environment Variables

In Vercel project settings → Environment Variables:

```
REACT_APP_API_URL=https://schoolmanagement-backend.onrender.com/api/
```

### Step 4: Deploy

1. Click **"Deploy"**
2. Wait for build (2-5 minutes)
3. Get your Vercel URL (e.g., `your-app.vercel.app`)

### Step 5: Update Backend CORS

1. Go back to Render Dashboard → Backend Service → Environment
2. Update `CORS_ALLOWED_ORIGINS`:
```
CORS_ALLOWED_ORIGINS=https://your-app.vercel.app
```
3. Save and wait for automatic redeployment

## ✅ Post-Deployment Checklist

- [ ] Backend health check returns 200
- [ ] Admin panel accessible
- [ ] Frontend loads successfully
- [ ] Login works (JWT authentication)
- [ ] API calls work from frontend
- [ ] File uploads work (test with small image)
- [ ] Database queries execute correctly

## 🔧 Troubleshooting

### Backend won't start
- Check Render logs for errors
- Verify all environment variables are set
- Ensure `DATABASE_URL` is correct
- Check Python version compatibility

### Database connection fails
- Verify `DATABASE_URL` format: `postgresql://user:password@host:port/dbname`
- Ensure database and web service are in same region
- Check database is running

### Frontend can't reach backend
- Verify `REACT_APP_API_URL` is correct
- Check CORS settings on backend
- Ensure backend is deployed and running
- Check browser console for CORS errors

### Static files not loading
- Verify `collectstatic` ran in build.sh
- Check WhiteNoise is in MIDDLEWARE
- Ensure `STATIC_ROOT` is set correctly

### 500 Internal Server Error
- Check Render logs
- Verify `DEBUG=False` in production
- Check database migrations ran
- Verify SECRET_KEY is set

## 📊 Free Tier Limitations

**Render Free Tier:**
- Web service spins down after 15 minutes of inactivity
- 50-second cold start when waking up
- 512 MB RAM
- PostgreSQL database: 90 days free, then $7/month

**Vercel Free Tier:**
- 100 GB bandwidth/month
- Serverless function execution
- No custom domains on free tier

## 🔄 Updating Your Deployment

### Backend Updates
```bash
git add .
git commit -m "Your update message"
git push
```
Render auto-deploys on push to main branch.

### Frontend Updates
```bash
git add .
git commit -m "Your update message"
git push
```
Vercel auto-deploys on push to main branch.

## 📞 Need Help?

- Render Documentation: https://render.com/docs
- Vercel Documentation: https://vercel.com/docs
- Django Deployment: https://docs.djangoproject.com/en/5.2/howto/deployment/

---

**Your deployment URLs:**
- Backend: `https://schoolmanagement-backend.onrender.com`
- Frontend: `https://your-app.vercel.app`
- Database: Internal PostgreSQL on Render
