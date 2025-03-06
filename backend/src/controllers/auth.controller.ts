/**
 * @module Controllers/Auth
 * @description This module is responsible for handling user registration and login.
 */
import { Request, Response } from "express";
import { isValidEmail } from "../utils/email";
import bcrypt from 'bcryptjs';
import { CompleteUser, ReturnUser } from "../models/user";
import { createUser, getByEmailAndPwd } from "../services/auth.service";
import { completeUserToCreateUser } from "../models/userDto";

/**
 * @function register
 * @description Handles user registration by validating the email, hashing the password, and creating the user in the database.
 * 
 * @param {Request} req - The Express request object containing the user's email and password.
 * @param {Response} res - The Express response object used to send the response back to the client.
 * @returns {Response} - A response with a success message and the created user data, or an error message.
 * @throws {Error} - If there is an error during the registration process.
 */
export const register = async (req: Request, res: Response) => {
    const { email, password }: { email: string, password: string } = req.body;
    try {
        const hashedPassword: string = await bcrypt.hash(password, 12);
        const validEmail: boolean = await isValidEmail(email);

        if (!validEmail) {
            return res.status(400).json({ message: "Email already exists" });
        }

        const user: CompleteUser = await createUser(email, hashedPassword);
        const returnUser: ReturnUser = completeUserToCreateUser(user);

        return res.status(201).json({ message: "User created successfully", user: returnUser });
    } catch (error) {
        if (error instanceof Error) {
            return res.status(400).json({ message: "Error creating user" });
        }
        return res.status(500).json({ message: "Internal Server Error" });
    }
}

/**
 * @function login
 * @description Handles user login by checking if the user exists and verifying the password.
 *
 * @param {Request} req - The Express request object containing the user's email and password.
 * @param {Response} res - The Express response object used to send the response back to the client.
 * @returns {Response} - A response with a success message and the user data, or an error message.
 * @throws {Error} - If there is an error during the login process.
 */
export const login = async (req: Request, res: Response) => {
    const { email, password }: { email: string, password: string } = req.body;
    try {
        const user: CompleteUser | null = await getByEmailAndPwd(email, password);
        if (!user) {
            return res.status(404).json({ message: "Invalid email or password" });
        }
        const returnUser: ReturnUser = completeUserToCreateUser(user);

        return res.status(200).json({ message: "User logged in successfully", user: returnUser });
    } catch (error) {
        if (error instanceof Error) {
            return res.status(404).json({ message: "Error logging in user" });
        }
        return res.status(500).json({ message: "Internal Server Error" });
    }
}
