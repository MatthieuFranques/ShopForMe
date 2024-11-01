import { CompleteUser } from "../models/user";
import prisma from "../utils/prisma";

export async function getUserById(id: number): Promise<CompleteUser | null> {
    try {
        const user = await prisma.user.findUnique({
            where: {
                id: id
            }
        });

        return user;
    } catch (error) {
        throw error;
    }
}

export async function getUserByEmail(email: string): Promise<CompleteUser | null> {
    try {
        const user = await prisma.user.findUnique({
            where: {
                email: email
            }
        });

        return user;
    } catch (error) {
        throw error;
    }
}

