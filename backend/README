# Backend API

A Node.js/TypeScript backend application using Express, Prisma ORM, Swagger API documentation for API, Typedoc for TypeScript documentation, Jest for testing and Docker for containerization

## Tech Stack

- **Node.js** with **TypeScript**
- **Express** for routing
- **Prisma** for ORM (compatible with PostgreSQL, MySQL, SQLite, and MongoDB)
- **Jest** for unit testing
- **Swagger** for REST API documentation
- **Docker** for containerization
- **TypeDoc** for TypeScript documentation

## Setup Instructions

### 1. Clone the Repository

```bash
git clone git@github.com:EpitechMscProPromo2025/T-ESP-902-71730-TLS-ShopForMe-3.git

cd T-ESP-902-71730-TLS-ShopForMe-3/backend
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Environment Variables

Create a `.env` file in the root directory of the project and fill it with your database credentials. You can use the `.env.template` file as a reference.

### 4. Database Setup

```bash
npm run prisma:generate
npm run prisma:migrate
```

### 5. Run the Application

```bash
npm run dev
```

### 6. API Documentation

The API documentation is available at `http://localhost:3000/api-docs` after running the application.

### 7. TypeScript Documentation

The TypeScript documentation is generated using Typedoc and can be found in the `docs` folder after running the following command:

npm run doc

```bash
open docs/index.html
```

### 8. Testing

To run the tests, use the following command:

```bash
npm run test
```

To generate a coverage report, use:

```bash
npm run test:coverage

open coverage/index.html
```

### 9. Docker

This project is containerized using Docker. You can run the application in a Docker container for both production and development environments. You have to have a .env file in the root of the project with your database credentials. You can use the `.env.template` file as a reference.

```bash
docker-compose up --build

```

For PRODUCTION : - Fill .env file with your database credentials (you have en exemple in .env.template).

    - Update Dockerfile for prod (You have all in the file).

    - RUN docker-compose up

For Developpement : - Fill .env file with your database credentials (you have en exemple in .env.template).

    - Update Dockerfile and docker-compose.yml files for dev (You have all in the files).

    - RUN docker-compose up

    - RUN npm run dev
