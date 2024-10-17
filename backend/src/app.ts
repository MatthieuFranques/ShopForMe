import express, { Application, Request, Response } from 'express';
import  userRouter  from './routes/user.route';
import dotenv from 'dotenv';
import shopRouter from "./routes/shop.route";
import cors from 'cors'

dotenv.config();

const app: Application = express();
const port = process.env.PORT || 3000;

const allowedOrigins = ['http://localhost:3000'];

const options: cors.CorsOptions = {
    origin: allowedOrigins
};

app.use(cors(options))
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/user', userRouter);
app.use('/shop', shopRouter);

app.get('/', (req: Request, res: Response) => {
    res.send('Hello World');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});