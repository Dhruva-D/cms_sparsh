#!/bin/bash
# Script to combine both repos into SMS_Render repository

echo "=========================================="
echo "SMS_Render Repository Setup"
echo "=========================================="
echo ""

# Step 1: Remove old git connections
echo "Step 1: Removing existing git connections..."
cd /d/intern2

# Backup old git folders (optional)
if [ -d "SchoolManagementBackend/.git" ]; then
    echo "  - Removing SchoolManagementBackend/.git"
    rm -rf SchoolManagementBackend/.git
fi

if [ -d "schoolmanagement_FrontEnd/.git" ]; then
    echo "  - Removing schoolmanagement_FrontEnd/.git"
    rm -rf schoolmanagement_FrontEnd/.git
fi

echo "  ✓ Old git connections removed"
echo ""

# Step 2: Check for existing .git in root
echo "Step 2: Checking root directory..."
if [ -d ".git" ]; then
    echo "  ⚠ Warning: .git already exists in root"
    echo "  Removing existing .git folder..."
    rm -rf .git
fi
echo ""

# Step 3: Initialize new git repository
echo "Step 3: Initializing new git repository..."
git init
git branch -M main
echo "  ✓ Git initialized with main branch"
echo ""

# Step 4: Add remote
echo "Step 4: Adding remote repository..."
git remote add origin https://github.com/swostitech-solutions/SMS_Render.git
echo "  ✓ Remote added: SMS_Render.git"
echo ""

# Step 5: Stage files
echo "Step 5: Staging files..."
git add .
echo "  ✓ Files staged"
echo ""

# Step 6: Commit
echo "Step 6: Creating initial commit..."
git commit -m "Initial commit: Combined frontend and backend for Render/Vercel deployment

- Backend: Django REST API with PostgreSQL support
- Frontend: React application with environment-based API URLs
- Deployment: Ready for Render (backend) and Vercel (frontend)
- Documentation: Complete deployment guides included"

echo "  ✓ Initial commit created"
echo ""

# Step 7: Push to remote
echo "Step 7: Pushing to remote repository..."
echo "  This will push to: https://github.com/swostitech-solutions/SMS_Render.git"
echo ""
read -p "  Press Enter to continue with push, or Ctrl+C to cancel..."

git push -u origin main

echo ""
echo "=========================================="
echo "✓ Repository setup complete!"
echo "=========================================="
echo ""
echo "Your code is now at:"
echo "https://github.com/swostitech-solutions/SMS_Render"
echo ""
echo "Next steps:"
echo "1. Deploy backend to Render (see RENDER_DEPLOYMENT_GUIDE.md)"
echo "2. Deploy frontend to Vercel (see VERCEL_DEPLOYMENT_GUIDE.md)"
echo "3. Follow QUICK_DEPLOY_CHECKLIST.md for step-by-step guide"
echo ""
