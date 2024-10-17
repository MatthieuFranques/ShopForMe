import { Request, Response } from "express";
import { CompleteUser } from "../models/user";
import { getUserByEmail, getUserById } from "../services/user.service";


type UserFilter = {
    id?: number;
    email?: string;
}

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

