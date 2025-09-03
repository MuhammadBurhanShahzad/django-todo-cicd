# Use Python 3.10 (compatible with Django 3.2)
FROM python:3.10-slim

# Set working directory
WORKDIR /data

# Install system dependencies (optional but useful)
RUN apt-get update && apt-get install -y python3-distutils python3-setuptools && rm -rf /var/lib/apt/lists/*

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

