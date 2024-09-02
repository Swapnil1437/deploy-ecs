# Stage 1: Build environment
FROM node:12.2.0-alpine AS build

# Working directory
WORKDIR /node

# Copy the code
COPY . .

# Install dependencies
RUN npm install

# Run tests
RUN npm run test

# Stage 2: Runtime environment
FROM node:12.2.0-alpine

# Working directory
WORKDIR /node

# Copy the built application from the previous stage
COPY --from=build /node .

# Expose port 8000
EXPOSE 8000

# Run the code
CMD ["node", "app.js"]

# Stage 3: Nginx environment
FROM nginx:alpine

# Working directory
WORKDIR /etc/nginx

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]

# Copy the Node.js application to the Nginx container
COPY --from=0 /node /var/www/node
