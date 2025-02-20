# Use a smaller base image
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Install necessary packages
RUN apk add --no-cache bash openssl

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Build the TypeScript code into the `dist` directory
RUN npm run build

# Remove dev dependencies after build
RUN npm prune --production

# Use a minimal runtime image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install OpenSSL in the final image as well
RUN apk add --no-cache openssl

# Copy built application from previous stage
COPY --from=build /app /app

# Expose the application port
EXPOSE ${BACKEND_PORT}

# Check database readiness before running the app
CMD ["sh", "-c", "sleep 3 && npx prisma db push && node dist/app.js"]
