# Use an NGINX base image (alpine variant for small size)
FROM nginx:alpine

# Remove default nginx index page and replace with our custom page
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 (though AWS security group controls access externally)
EXPOSE 80

# Start NGINX in foreground (so container doesn't exit)
CMD ["nginx", "-g", "daemon off;"]
