FROM node:20

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# For development
CMD ["sh", "-c", "npm run prisma:migrate && npm run prisma:generate && npm run dev"]


# For production
# RUN npm run build

# RUN npx prisma generate

# RUN npx prisma migrate deploy

# EXPOSE 3000

# CMD ["node", "dist/app.ts"]