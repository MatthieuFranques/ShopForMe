import swaggerJSDoc, {SwaggerDefinition} from 'swagger-jsdoc';

const swaggerDefinition: SwaggerDefinition = {
    openapi: '3.0.0',
    info: {
        title: 'API Documentation Shop For Me',
        version: '1.0.0',
        description: 'Documentation de l\'API pour l\'application Express',
    },
    servers: [
        {
            url: 'http://localhost:8080',
        },
    ],
};

const options = {
    swaggerDefinition,
    apis: ['./src/routes/*.ts'],
};

export const swaggerSpec = swaggerJSDoc(options);