import { Request, Response } from "express";
import {
    create,
    get,
    getOne,
    update,
    getFree,
    getAllProductByShop,
    addNewProductToRayon,
    getProductsBySectionName,
    getSectionByProductId
} from "../services/product.service";



export const getProductById = async (req: Request, res: Response) => {
    try {
        const shop = await getOne(parseInt(req.params.id));
        return res.status(200).json(shop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error"});
    }
}

export const updateProduct = async (req: Request, res: Response) => {
    try {
        const updatedShop = await update(parseInt(req.params.id), req.body);
        return res.status(200).json(updatedShop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

export const createProduct = async (req: Request, res: Response) => {
    try {
        const shop = await create(req.body)
        return res.status(201).json(shop)
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}


export const getAllProducts = async (req: Request, res: Response) => {
    try {
        const shops = await get();
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

export const getFreeProduct = async (req: Request, res: Response) => {
    try {
        const shops = await getFree(parseInt(req.params.id));
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

export const getAllProductByShopP = async (req: Request, res: Response) => {
    try {
        const shops = await getAllProductByShop(parseInt(req.params.id));
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

export const addNewProductToRayonP = async (req: Request, res: Response) => {
    try {
        const {storeId, productId, name} = req.body;
        const shops = await addNewProductToRayon(storeId, productId, name);
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

export const getProductsBySectionNameP = async (req: Request, res: Response) => {
    try {
        const name = req.params.id;
        const shops = await getProductsBySectionName(name);
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

export const getSectionByProductIdP = async (req: Request, res: Response) => {
    try {
        const id = parseInt(req.params.id)
        const section = await getSectionByProductId(id);
        return res.status(200).json(section);
    }
    catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}
