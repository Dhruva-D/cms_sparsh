#!/usr/bin/env bash
# Build script for Render deployment

set -o errexit  # Exit on error

echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Collecting static files..."
python manage.py collectstatic --no-input

echo "Running database migrations..."
python manage.py migrate --no-input

echo "Creating superuser if it doesn't exist..."
python manage.py shell << 'END'
from django.contrib.auth import get_user_model
from Acadix.models import Organization, Branch, UserType
import os

User = get_user_model()
user_name = os.environ.get('DJANGO_SUPERUSER_USERNAME', 'admin')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD', 'admin123')

# Create default organization, branch, and user type if they don't exist
org, _ = Organization.objects.get_or_create(
    id=1, 
    defaults={
        'organization_code': 'ORG001',
        'organization_description': 'Default Organization',
        'created_by': 0
    }
)
branch, _ = Branch.objects.get_or_create(
    id=1, 
    defaults={
        'organization': org,
        'branch_code': 'MAIN',
        'branch_name': 'Main Branch',
        'created_by': 0
    }
)
user_type, _ = UserType.objects.get_or_create(
    id=1, 
    defaults={
        'user_type': 'Admin',
        'description': 'Administrator',
        'created_by': 0
    }
)

# Create superuser if it doesn't exist
if not User.objects.filter(user_name=user_name).exists():
    User.objects.create_superuser(
        user_name=user_name,
        password=password,
        organization=org,
        branch=branch,
        user_type=user_type
    )
    print(f'Superuser "{user_name}" created successfully!')
else:
    print(f'Superuser "{user_name}" already exists.')
END

echo "Build completed successfully!"
