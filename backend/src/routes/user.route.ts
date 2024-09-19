import { Router } from 'express';
import { login, register } from '../controllers/auth.controller';
import { getUser } from '../controllers/user.controller';

const userRouter = Router();

userRouter.post('/register', register);
userRouter.post('/login', login);
userRouter.get('', getUser)

export default userRouter;