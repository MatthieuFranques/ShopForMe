# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Launch the application using docker

In the project directory copy the .env.template as a .env file.

RUN docker-compose up

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.\
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

# Frontend

This project is a frontend application built with React and TypeScript. It is designed to work with a backend API and provides a user interface for interacting with the API.

## Tech Stack

- **React**: A JavaScript library for building user interfaces.
- **TypeScript**: A superset of JavaScript that adds static typing.
- **MUI**: A popular React UI framework that provides pre-designed components.

## Setup Instructions

1. **Clone the Repository**

```bash
git clone git@github.com:EpitechMscProPromo2025/T-ESP-902-71730-TLS-ShopForMe-3.git

cd T-ESP-902-71730-TLS-ShopForMe-3/frontend
```

2. **Install Dependencies**

```bash
npm install
```

3. **Environment Variables**

Create a `.env` file in the root directory of the project and fill it with your API URL. You can use the `.env.template` file as a reference.

4. **Run the Application**

```bash
npm start
```

This will start the development server and open the application in your default web browser.
The application will be available at `http://localhost:9000`.

5. **Build the Application**

```bash
npm run build
```

This will create a production build of the application in the `build` directory.

You can then deploy the contents of the `build` directory to your web server.

6. **Docker**

This project is containerized using Docker. You can run the application in a Docker container for both production and development environments. You have to have a .env file in the root of the project with your database credentials. You can use the `.env.template` file as a reference.

```bash
docker-compose up
```
