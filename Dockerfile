# Stage 1: Build the application
FROM node:12.2.0-alpine AS build-stage
WORKDIR /app

COPY . .

RUN npm install

RUN npm run test

EXPOSE 8000

CMD ["node", "app.js"]

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

WORKDIR /etc/nginx

COPY --from=build-stage /app /var/www/node

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
