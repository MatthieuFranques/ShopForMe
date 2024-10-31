import { CompleteUser } from "../models/user";
import bcrypt from 'bcryptjs';
import prisma from "../utils/prisma";

export async function createUser (validEmail: string, hashedPassword: string): Promise<CompleteUser> {
    try {
        const user : CompleteUser = await prisma.user.create({
            data: {
                email: validEmail,
                password: hashedPassword
            }
        });
        return user;

    } catch (error) {
        throw error;
    }
}

export async function getByEmailAndPwd(email: string, password: string): Promise<CompleteUser | null> {
    try {
        

        const user : CompleteUser | null = await prisma.user.findFirst({
            where: {
                email: email,
            }
        });

        if(!user){
            return null;
        }

        const validPassword : boolean = await bcrypt.compare(password, user.password);

        if(!validPassword){
            return null;
        }
        return user;
    } catch (error) {
        throw error;
    }
}

