# Step 1: Build React app
FROM node:18-alpine AS builder
WORKDIR /app
ARG REACT_APP_API_PORT
ENV REACT_APP_API_PORT=${REACT_APP_API_PORT}
ARG REACT_APP_API_KEY
ENV REACT_APP_API_KEY=${REACT_APP_API_KEY}
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile
COPY . .
RUN npm run build

# Step 2: Serve with Nginx
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
