# Use RabbitMQ's management image based on Alpine for a lightweight base
FROM rabbitmq:alpine

# Add a non-root user and group for security purposes
RUN addgroup -g 2000 -S appgroup \
    && adduser -DH -s /sbin/nologin -u 2000 -G appgroup -S appuser

# Set the working directory to /app
WORKDIR /app

# Copy the Nginx configuration and entrypoint script into the container
# Ensure these files are in the build context
COPY --chown=appuser nginx.conf /etc/nginx/nginx.conf
COPY --chown=appuser entrypoint.sh ./entrypoint.sh

# Set default environment variables for RabbitMQ
ENV RABBITMQ_DEFAULT_USER=myuser
ENV RABBITMQ_DEFAULT_PASS=mypassword

# Install Nginx and the Nginx stream module
RUN apk add --no-cache nginx nginx-mod-stream

# Create necessary directories for Nginx and set permissions
RUN mkdir -p /var/cache/nginx /run/nginx /var/log/nginx \
    && chown -R appuser:appgroup /var/cache/nginx /run/nginx /var/log/nginx \
    && chmod +x ./entrypoint.sh

# Define the entry point script to start the services
ENTRYPOINT ["./entrypoint.sh"]
