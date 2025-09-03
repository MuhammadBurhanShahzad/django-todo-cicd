# Use Python 3.10 (compatible with Django 3.2)
FROM python:3.10-slim

# Set working directory
WORKDIR /data

# Install pip/setuptools/wheel (modern replacements for distutils)
RUN pip install --upgrade pip setuptools wheel

# Install Django
RUN pip install --no-cache-dir django==3.2

# Copy project files
COPY . .

# Run migrations
RUN python manage.py migrate

# Expose port
EXPOSE 8000

# Start Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
