import { Request, Response } from "express";
import  prisma  from "../utils/prisma";
import {isValidEmail} from "../utils/email";
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { CreateUser } from "../models/user";
import { createUser } from "../services/auth.service";

export const register = async (req: Request, res: Response) => {
    const {email, password} : {email: string, password:string} = req.body;
    try {
        const hashedPassword : string = await bcrypt.hash(password, 12);
        const validEmail : boolean = await isValidEmail(email);

        if(!validEmail){
            return res.status(400).json({message: "Email already exists"});
        }

        const user : CreateUser = await createUser(email, hashedPassword);

        return res.status(201).json({message: "User created successfully", user: user});
    } catch (error) {
        if(error instanceof Error){
            return res.status(400).json({message: "Error creating user"});
        }
        return res.status(500).json({message: "Internal Server Error"});
    }
}