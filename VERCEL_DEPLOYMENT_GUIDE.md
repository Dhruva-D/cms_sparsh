# School Management Frontend - Vercel Deployment

## 🚀 Quick Deploy to Vercel

### Option 1: Using Vercel Dashboard (Recommended)

1. **Go to Vercel**: https://vercel.com
2. **Sign in** with GitHub
3. **Import Project**:
   - Click "Add New" → "Project"
   - Select your GitHub repository
   - Select `schoolmanagement_FrontEnd` as root directory (if monorepo)
4. **Configure**:
   - Framework Preset: `Create React App`
   - Build Command: `npm run build` (auto-detected)
   - Output Directory: `build` (auto-detected)
   - Install Command: `npm install` (auto-detected)
5. **Add Environment Variable**:
   - Key: `REACT_APP_API_URL`
   - Value: `https://your-backend-app.onrender.com/api/`
6. **Deploy**: Click "Deploy"

### Option 2: Using Vercel CLI

```bash
# Install Vercel CLI
npm install -g vercel

# Navigate to frontend directory
cd d:\intern2\schoolmanagement_FrontEnd

# Login to Vercel
vercel login

# Deploy
vercel

# Follow prompts:
# - Set up and deploy: Y
# - Which scope: Select your account
# - Link to existing project: N
# - Project name: schoolmanagement-frontend
# - Directory: ./
# - Override settings: N

# Add environment variable
vercel env add REACT_APP_API_URL

# Paste your backend URL when prompted:
# https://your-backend-app.onrender.com/api/

# Deploy to production
vercel --prod
```

## 📝 Configuration Files Created

- ✅ `vercel.json` - Vercel configuration for SPA routing
- ✅ `.env.example` - Environment variables template
- ✅ Updated `ApiUrl.jsx` - Dynamic API URL configuration

## 🔧 Environment Variables

Add in Vercel Dashboard → Settings → Environment Variables:

| Variable | Value | Environment |
|----------|-------|-------------|
| `REACT_APP_API_URL` | `https://your-backend.onrender.com/api/` | Production, Preview |

## ✅ Deployment Checklist

### Before Deployment:
- [x] `vercel.json` created
- [x] API URL uses environment variable
- [x] `.env.example` documented
- [ ] Code pushed to GitHub
- [ ] Backend deployed and URL ready

### During Deployment:
- [ ] Repository connected to Vercel
- [ ] Environment variable configured
- [ ] Build succeeds
- [ ] Preview deployment works

### After Deployment:
- [ ] Frontend loads successfully
- [ ] API calls work (check Network tab)
- [ ] Login functionality works
- [ ] Update backend CORS settings
- [ ] Test all critical features

## 🔄 Connecting Frontend to Backend

### Update Backend CORS Settings

Once frontend is deployed, update backend environment variables:

**On Render Dashboard** → Your Backend Service → Environment:

```
CORS_ALLOWED_ORIGINS=https://your-app.vercel.app
```

If you have multiple deployments (staging, production):
```
CORS_ALLOWED_ORIGINS=https://your-app.vercel.app,https://your-app-staging.vercel.app
```

## 🌐 Custom Domain (Optional)

### Add Custom Domain to Vercel:

1. Go to Project Settings → Domains
2. Add your domain (e.g., `schoolmanagement.com`)
3. Configure DNS:
   - Type: `CNAME`
   - Name: `@` or `www`
   - Value: `cname.vercel-dns.com`
4. Wait for DNS propagation (5-30 minutes)

### Update Backend CORS:

```
CORS_ALLOWED_ORIGINS=https://schoolmanagement.com,https://www.schoolmanagement.com
```

## 📊 Vercel Features

### Automatic Deployments
- **Every push to main** → Production deployment
- **Every PR** → Preview deployment
- **Every branch** → Preview deployment (optional)

### Preview Deployments
Each pull request gets a unique preview URL:
- `https://your-app-git-feature-branch.vercel.app`

### Build Logs
View real-time build logs in Vercel Dashboard

### Analytics (Pro Plan)
- Page views
- Performance metrics
- Visitor insights

## 🔧 Troubleshooting

### Build Fails

**Memory Issues:**
```json
// In package.json, ensure:
"scripts": {
  "build": "node --max-old-space-size=4096 ./node_modules/react-scripts/scripts/build.js"
}
```
✅ Already configured in your package.json

**Dependency Issues:**
```bash
# Delete and reinstall
rm -rf node_modules package-lock.json
npm install
```

### API Calls Fail

1. **Check Network Tab** (F12 → Network)
   - Is API URL correct?
   - Any CORS errors?

2. **Verify Environment Variable:**
   ```bash
   # In Vercel CLI
   vercel env ls
   ```

3. **Check Backend CORS:**
   - Ensure frontend URL is in `CORS_ALLOWED_ORIGINS`
   - Check backend logs for CORS errors

4. **Backend Not Responding:**
   - Render free tier: 50s cold start
   - Check backend status on Render dashboard

### 404 on Page Refresh

✅ Already fixed with `vercel.json` rewrites configuration

### Environment Variables Not Working

- Variables must start with `REACT_APP_`
- Need to rebuild after adding variables
- Check they're set for correct environment (Production/Preview)

## 📱 Multiple Environments

### Setup Staging Environment:

1. Create new Vercel project from same repo
2. Use different branch (e.g., `staging`)
3. Set different environment variable:
   ```
   REACT_APP_API_URL=https://backend-staging.onrender.com/api/
   ```

### Setup Local Development:

Create `.env.local` (gitignored):
```
REACT_APP_API_URL=http://127.0.0.1:8000/api/
```

## 🔐 Security Headers

✅ Already configured in `vercel.json`:
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- X-XSS-Protection: 1; mode=block

## 📈 Performance Optimization

### Already Optimized:
- ✅ Build with memory allocation (4GB)
- ✅ Vercel CDN for static files
- ✅ Automatic code splitting (Create React App)

### Additional Optimizations:
- Enable Vercel Analytics (Pro)
- Add service worker (PWA)
- Implement lazy loading for routes

## 🔄 Redeployment

### Trigger Redeploy:

**From Vercel Dashboard:**
1. Go to Deployments
2. Click "..." on latest deployment
3. Click "Redeploy"

**From CLI:**
```bash
vercel --prod
```

**From Git:**
```bash
git commit --allow-empty -m "Trigger redeploy"
git push
```

## 💰 Costs

### Free Tier Includes:
- Unlimited deployments
- 100 GB bandwidth/month
- Automatic HTTPS
- Preview deployments
- Serverless functions

### Paid Plans:
- **Pro ($20/month)**: Analytics, more bandwidth
- **Enterprise**: Custom pricing

## 📞 Support Resources

- Vercel Documentation: https://vercel.com/docs
- Vercel Community: https://github.com/vercel/vercel/discussions
- React Deployment: https://create-react-app.dev/docs/deployment

---

## Your Deployment URLs

**Frontend (Vercel):**
- Production: `https://your-app.vercel.app`
- Custom domain: `https://yourdomain.com` (if configured)

**Backend (Render):**
- API: `https://your-backend.onrender.com/api/`

**Make sure both are updated with each other's URLs!**
