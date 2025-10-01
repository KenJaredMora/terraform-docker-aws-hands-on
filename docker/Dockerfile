FROM nginx:alpine

# Remove default nginx index page and replace with my custom page
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
