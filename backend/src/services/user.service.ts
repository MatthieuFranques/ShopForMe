/**
 * @module Services/User
 * @description This module is responsible for handling user retrieval.
 */
import { CompleteUser } from "../models/user";
import prisma from "../utils/prisma";

/**
 * @function getUserById
 * @description Fetch a user by their ID.
 * 
 * @param {number} id - The ID of the user.
 * @returns {Promise<CompleteUser | null>} - The user if found, or null if not.
 * @throws {Error} - If an error occurs during the query.
 */
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

/**
 * @function getUserByEmail
 * @description Fetch a user by their email.
 * 
 * @param {string} email - The email of the user.
 * @returns {Promise<CompleteUser | null>} - The user if found, or null if not.
 * @throws {Error} - If an error occurs during the query.
 */
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

