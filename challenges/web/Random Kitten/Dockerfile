FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt install -y libfcgi-dev nginx fcgiwrap spawn-fcgi supervisor && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Copy Nginx configuration
COPY src/default.conf /etc/nginx/sites-available/default

# Compile the FastCGI application
COPY cgi cgi

# Copy images
COPY images /images

# Copy HTML files
COPY src/index.html /var/www/html/index.html

# Copy the flag
COPY flag /devcore/flag

# Supervisor configuration
COPY src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start supervisord
CMD ["/usr/bin/supervisord"]
