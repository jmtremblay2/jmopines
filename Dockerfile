# Use the official NGINX image from Docker Hub
FROM nginx:alpine

# Remove the default NGINX index page
RUN rm -rf /usr/share/nginx/html/*

# Copy the public folder (Hugo's generated files) into the NGINX container
COPY ./public /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start NGINX when the container starts
CMD ["nginx", "-g", "daemon off;"]