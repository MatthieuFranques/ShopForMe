import express, { Application, Request, Response } from 'express';
import  userRouter  from './routes/user.route';
import dotenv from 'dotenv';
import shopRouter from "./routes/shop.route";
import cors from 'cors'
import productRoute from "./routes/product.route";
import swaggerUi from 'swagger-ui-express';
import {swaggerSpec} from "./swagger";

dotenv.config();

export const app: Application = express();
const port = process.env.BACKEND_PORT;

const allowedOrigins = ['http://localhost:3000', 'http://91.121.191.34']

const options: cors.CorsOptions = {
    origin: allowedOrigins
};

app.use(cors(options))
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