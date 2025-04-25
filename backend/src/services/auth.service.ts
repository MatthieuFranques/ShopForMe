/**
 * @module Services/Auth
 * @description This module is responsible for handling user registration and login.
 */
import { CompleteUser } from "../models/user";
import bcrypt from 'bcryptjs';
import prisma from "../utils/prisma";

/**
 * @function createUser
 * @description Create a new user in the database.
 * 
 * @param {string} validEmail - The email address of the new user (must be validated beforehand).
 * @param {string} hashedPassword - The hashed password of the new user.
 * @returns {Promise<CompleteUser>} - The newly created user.
 * @throws {Error} - If an error occurs during user creation.
 */
export async function createUser(validEmail: string, hashedPassword: string): Promise<CompleteUser> {

    const user: CompleteUser = await prisma.user.create({
        data: {
            email: validEmail,
            password: hashedPassword
        }
    });
    return user;
}

/**
 * @function getByEmailAndPwd
 * @description Retrieve a user from the database by email and verify the password.
 * 
 * @param {string} email - The email address of the user to retrieve.
 * @param {string} password - The password of the user to validate.
 * @returns {Promise<CompleteUser | null>} - The user if the email and password are valid, null otherwise.
 * @throws {Error} - If an error occurs while fetching or validating the user.
 */
export async function getByEmailAndPwd(email: string, password: string): Promise<CompleteUser | null> {

    const user: CompleteUser | null = await prisma.user.findFirst({
        where: {
            email: email,
        }
    });

    if (!user) {
        return null;
    }

    const validPassword: boolean = await bcrypt.compare(password, user.password);

    if (!validPassword) {
        return null;
    }

    return user;
}
