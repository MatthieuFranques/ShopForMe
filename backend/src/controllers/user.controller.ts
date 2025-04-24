/**
 * @module Controllers/User
 * @description This module is responsible for handling user retrieval.
 */

import { Request, Response } from "express";
import { CompleteUser } from "../models/user";
import { getUserByEmail, getUserById } from "../services/user.service";

// Type for user filtering by ID or email
type UserFilter = {
    id?: number;
    email?: string;
}

/**
 * @function getUser
 * @description Retrieves a user based on a query parameter (either ID or email).
 * 
 * @param {Request} req - The Express request object containing query parameters: `params` and `value`.
 * @param {Response} res - The Express response object used to send the user data or an error message.
 * @returns {Response} - A response with the user data if found, or an error message if not found or if the query parameters are invalid.
 * @throws {Error} - If there is an internal error during the retrieval process.
 */
export const getUser = async (req: Request, res: Response) => {
    try {
        const {params, value} = req.query;
        if(!params || !value){
            return res.status(400).json({message: "Invalid query parameters"});
        }
        let filter: UserFilter = {};
        let user: CompleteUser | null = null;

        switch(params){
            case "id":
                filter.id = parseInt(value as string);
                user = await getUserById(filter.id);
                break;
            case "email":
                filter.email = value as string;
                user = await getUserByEmail(filter.email);                
                break;
            default:
                return res.status(400).json({message: "Invalid query parameters"});
        }

        if(!user){
            return res.status(404).json({message: "User not found"});
        }


        return res.status(200).json({message: "User found", user: user});

    } catch (error) {
        return res.status(500).json({message: "Internal Server Error"});
    }
}

