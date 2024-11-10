# Step 1: Build the React application
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the source code
COPY . ./

# Build the React app
RUN npm run build

# Step 2: Serve the React app with Nginx
FROM nginx:alpine

# Ensure proper permissions for Nginx directories
RUN mkdir -p /var/cache/nginx/client_temp && \
    chown -R nginx:nginx /var/cache/nginx /usr/share/nginx/html

# Copy the build output to the Nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]
