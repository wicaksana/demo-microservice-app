import os
import time
import psycopg2
from flask import Flask

app = Flask(__name__)

# Database connection parameters from environment variables (set in docker-compose.yaml)
DB_HOST = os.environ.get("POSTGRES_HOST")
DB_NAME = os.environ.get("POSTGRES_DB")
DB_USER = os.environ.get("POSTGRES_USER")
DB_PASS = os.environ.get("POSTGRES_PASSWORD")

def get_db_connection():
    """Tries to establish a connection to the PostgreSQL database with retries."""
    conn = None
    max_retries = 10
    retry_delay = 3 # seconds

    for attempt in range(max_retries):
        try:
            conn = psycopg2.connect(
                host=DB_HOST,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASS
            )
            print("Successfully connected to the database!")
            return conn
        except psycopg2.OperationalError as e:
            print(f"Database connection failed (attempt {attempt + 1}/{max_retries}): {e}")
            if attempt < max_retries - 1:
                time.sleep(retry_delay)
            else:
                # Re-raise the error on the last attempt
                raise e
    return None

@app.route('/')
def index():
    try:
        conn = get_db_connection()
        if conn is None:
            return "<h1>Service Unavailable</h1><p>Could not establish database connection after multiple retries.</p>", 503

        cursor = conn.cursor()
        
        # 1. Query the simple data
        cursor.execute("SELECT message, created_at FROM messages ORDER BY created_at DESC LIMIT 1;")
        record = cursor.fetchone()
        
        # 2. Format the result
        if record:
            message, created_at = record
            response_html = f"""
            <div class="p-6 bg-green-100 border border-green-400 rounded-lg shadow-md">
                <h2 class="text-xl font-semibold text-green-800 mb-2">Query Result from PostgreSQL:</h2>
                <p class="text-gray-700"><strong>Message:</strong> {message}</p>
                <p class="text-gray-700"><strong>Timestamp:</strong> {created_at.strftime('%Y-%m-%d %H:%M:%S')}</p>
            </div>
            """
        else:
            response_html = """
            <div class="p-6 bg-yellow-100 border border-yellow-400 rounded-lg shadow-md">
                <h2 class="text-xl font-semibold text-yellow-800 mb-2">Database Ready</h2>
                <p class="text-gray-700">No records found in the 'messages' table.</p>
            </div>
            """

        cursor.close()
        conn.close()

    except Exception as e:
        response_html = f"""
        <div class="p-6 bg-red-100 border border-red-400 rounded-lg shadow-md">
            <h2 class="text-xl font-semibold text-red-800 mb-2">Error Processing Request</h2>
            <p class="text-gray-700">An error occurred: {e}</p>
        </div>
        """

    # Basic HTML Structure with Tailwind CSS for aesthetics
    return f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Microservice App Result</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {{ font-family: 'Inter', sans-serif; }}
    </style>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen">
    <div class="w-full max-w-2xl bg-white p-8 rounded-xl shadow-2xl space-y-6">
        <h1 class="text-3xl font-bold text-gray-800 border-b pb-4">Web App Microservice Status</h1>
        <p class="text-gray-600">This app is served via Nginx and fetches data from the Postgres service.</p>
        
        {response_html}

        <div class="mt-6 p-4 text-sm text-gray-500 border-t pt-4">
            <p>Services: Nginx (Proxy) -> WebApp (Flask/Python) -> Postgres (DB)</p>
        </div>
    </div>
</body>
</html>
"""

if __name__ == '__main__':
    # Flask runs on port 5000 inside the Docker container
    app.run(host='0.0.0.0', port=5000)