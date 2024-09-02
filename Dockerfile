# Stage 1: Build the application
FROM node:12.2.0-alpine AS build-stage
WORKDIR /app

COPY . .

RUN npm install
RUN npm run test

# Stage 2: Serve the application with Nginx
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY config/nginx.conf /etc/nginx/conf.d/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
