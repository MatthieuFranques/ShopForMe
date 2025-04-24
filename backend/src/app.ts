import express, { Application, NextFunction, Request, Response } from 'express';
import  userRouter  from './routes/user.route';
import dotenv from 'dotenv';
import shopRouter from "./routes/shop.route";
import productRoute from "./routes/product.route";
import swaggerUi from 'swagger-ui-express';
import {swaggerSpec} from "./swagger";

dotenv.config();

export const app: Application = express();

const port = process.env.BACKEND_PORT;
const API_KEY = process.env.API_KEY;

app.use((req: Request, res: Response, next: NextFunction) => {
    res.setHeader("Access-Control-Allow-Origin", "*"); // Allow all origins
    res.setHeader("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type, x-api-key");

    if (req.method === "OPTIONS") {
        return res.sendStatus(204);
    }

    next();
});

// Middleware to enforce API key authentication
const authenticateAPIKey = (req: Request, res: Response, next: NextFunction) => {
    const clientApiKey = req.headers['x-api-key']; // Expecting a custom header "x-api-key"

    if (!clientApiKey || clientApiKey !== API_KEY) {
        return res.status(403).json({ error: "Forbidden: Invalid API Key" });
    }

    next();
};

app.use(authenticateAPIKey);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/users', userRouter);
app.use('/shops', shopRouter);
app.use('/products', productRoute);

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));


app.get('/', (req: Request, res: Response) => {
    res.send('Bienvenue sur notre API !');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});