# Use the official Python base image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Install build dependencies required for psycopg2 (PostgreSQL client)
# and clean up afterward
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements file and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app.py ./

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]