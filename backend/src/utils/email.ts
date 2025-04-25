import { EmailUser } from "../models/user";
import prisma from "./prisma";
/**
 * Regular expression to validate email format
 */
const emailRegex: RegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;


/**
 * Checks if email is valid and not already use in the database.
 * 
 * @param {string} email - Email to validate 
 * @returns {Promise<boolean>} - True if email is valid and not already in use, false otherwise
 * @throws {Error} - Throws error if database query fails or error occurs
 */
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
        result = !emailExists;
    }
    return result;
}



