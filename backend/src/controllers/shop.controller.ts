import { Request, Response } from "express";
import { createShop, getShopById, updateShop, getAllShops, deleteShop } from "../services/shop.service";



export const getShopByIdC = async (req: Request, res: Response) => {
    try {
        const shop = await getShopById(parseInt(req.params.id));
        return res.status(200).json(shop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error"});
    }
}

export const updateShopC = async (req: Request, res: Response) => {
    try {
        const updatedShop = await updateShop(parseInt(req.params.id), req.body);
        return res.status(200).json(updatedShop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

export const removeShopC = async (req: Request, res: Response) => {
    try {
        const updatedShop = await deleteShop(parseInt(req.params.id));
        return res.status(200).json(updatedShop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

export const createShopC = async (req: Request, res: Response) => {
    try {
        const shop = await createShop(req.body)
        return res.status(201).json(shop)
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}


export const getAllShopsC = async (req: Request, res: Response) => {
    try {
        const shops = await getAllShops();
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}
