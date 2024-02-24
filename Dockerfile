
# Stage 2
FROM --platform=linux/amd64 nginx:1.21.1-alpine
COPY ./build/web/ /usr/share/nginx/html