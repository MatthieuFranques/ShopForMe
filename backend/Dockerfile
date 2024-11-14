FROM node:18-bullseye

# Set the working directory
WORKDIR /app

# Install netcat for the entrypoint script
RUN apt-get update && apt-get install -y netcat

# Copy only the package.json and package-lock.json for dependency installation
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Copy Prisma schema and generate client
COPY prisma ./prisma
RUN npx prisma generate

# Build the TypeScript code into the `dist` directory
RUN npm run build

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Start the application using the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "dist/app.js"]
