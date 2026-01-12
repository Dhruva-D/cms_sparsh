@echo off
REM Script to combine both repos into SMS_Render repository (Windows)

echo ==========================================
echo SMS_Render Repository Setup
echo ==========================================
echo.

REM Step 1: Remove old git connections
echo Step 1: Removing existing git connections...
cd /d D:\intern2

if exist "SchoolManagementBackend\.git\" (
    echo   - Removing SchoolManagementBackend\.git
    rmdir /s /q "SchoolManagementBackend\.git"
)

if exist "schoolmanagement_FrontEnd\.git\" (
    echo   - Removing schoolmanagement_FrontEnd\.git
    rmdir /s /q "schoolmanagement_FrontEnd\.git"
)

echo   [OK] Old git connections removed
echo.

REM Step 2: Check for existing .git in root
echo Step 2: Checking root directory...
if exist ".git\" (
    echo   [WARNING] .git already exists in root
    echo   Removing existing .git folder...
    rmdir /s /q ".git"
)
echo.

REM Step 3: Initialize new git repository
echo Step 3: Initializing new git repository...
git init
git branch -M main
echo   [OK] Git initialized with main branch
echo.

REM Step 4: Add remote
echo Step 4: Adding remote repository...
git remote add origin https://github.com/swostitech-solutions/SMS_Render.git
echo   [OK] Remote added: SMS_Render.git
echo.

REM Step 5: Stage files
echo Step 5: Staging files...
git add .
echo   [OK] Files staged
echo.

REM Step 6: Commit
echo Step 6: Creating initial commit...
git commit -m "Initial commit: Combined frontend and backend for Render/Vercel deployment" -m "- Backend: Django REST API with PostgreSQL support" -m "- Frontend: React application with environment-based API URLs" -m "- Deployment: Ready for Render (backend) and Vercel (frontend)" -m "- Documentation: Complete deployment guides included"

echo   [OK] Initial commit created
echo.

REM Step 7: Push to remote
echo Step 7: Pushing to remote repository...
echo   This will push to: https://github.com/swostitech-solutions/SMS_Render.git
echo.
pause

git push -u origin main

echo.
echo ==========================================
echo [OK] Repository setup complete!
echo ==========================================
echo.
echo Your code is now at:
echo https://github.com/swostitech-solutions/SMS_Render
echo.
echo Next steps:
echo 1. Deploy backend to Render (see RENDER_DEPLOYMENT_GUIDE.md)
echo 2. Deploy frontend to Vercel (see VERCEL_DEPLOYMENT_GUIDE.md)
echo 3. Follow QUICK_DEPLOY_CHECKLIST.md for step-by-step guide
echo.
pause
