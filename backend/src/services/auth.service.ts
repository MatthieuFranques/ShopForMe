import { CreateUser } from "../models/user";
import prisma from "../utils/prisma";

export async function createUser (validEmail: string, hashedPassword: string): Promise<CreateUser> {
    try {
        const user : CreateUser = await prisma.user.create({
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