FROM nginx:latest

LABEL Simon Bustamante <simon.bustamante@gmail.com>

# Make snakeoil certificates available
RUN apt-get update && apt-get install -qy ssl-cert

#Adding NGINX configuration
COPY site.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
