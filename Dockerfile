# For production usage with nginx and wsgi
FROM tiangolo/uwsgi-nginx-flask:python3.8

# Main folder for container
WORKDIR /app

# Copy the application dependencies file
COPY requirements.txt .

# Install the dependencies
RUN pip install -r requirements.txt

# Copy the application to the working directory
COPY api/main.py api/util.py api/hello_world.py /app/

# Exposing port 5000 as Flask App uses it
EXPOSE 5000/tcp

