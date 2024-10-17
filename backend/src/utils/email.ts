import { EmailUser } from "../models/user";
import prisma from "./prisma";

const emailRegex: RegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

export async function isValidEmail(email: string): Promise<boolean> {
    let result: boolean = emailRegex.test(email);

    if(result){
        const emailExists : EmailUser | null = await prisma.user.findFirst({
            where: {
                email: email
            }, select : {
                email: true
            }
        });
        result = emailExists ? false : true;
    }
    return result;
}



