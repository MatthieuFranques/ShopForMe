/**
 * @module Controllers/Product
 * @description This module is responsible for handling product creation, retrieval, and updating.
 */
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


/**
 * @function getProductById
 * @description Retrieves a product by its ID.
 * 
 * @param {Request} req - The Express request object containing the product ID as a URL parameter.
 * @param {Response} res - The Express response object used to send the product data.
 * @returns {Response} - A response with the product data or an error message.
 * @throws {Error} - If there is an error retrieving the product.
 */
export const getProductById = async (req: Request, res: Response) => {
    try {
        const shop = await getOne(parseInt(req.params.id));
        return res.status(200).json(shop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error"});
    }
}

/**
 * @function updateProduct
 * @description Updates a product by its ID with the provided data.
 *
 * @param {Request} req - The Express request object containing the product ID and update data in the body.
 * @param {Response} res - The Express response object used to send the updated product data.
 * @returns {Response} - A response with the updated product data or an error message.
 * @throws {Error} - If there is an error updating the product.
 */
export const updateProduct = async (req: Request, res: Response) => {
    try {
        const updatedShop = await update(parseInt(req.params.id), req.body);
        return res.status(200).json(updatedShop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function createProduct
 * @description Creates a new product using the data provided in the request body.
 *
 * @param {Request} req - The Express request object containing the new product data in the body.
 * @param {Response} res - The Express response object used to send the created product data.
 * @returns {Response} - A response with the newly created product or an error message.
 * @throws {Error} - If there is an error creating the product.
 */
export const createProduct = async (req: Request, res: Response) => {
    try {
        const shop = await create(req.body)
        return res.status(201).json(shop)
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function getAllProducts
 * @description Retrieves all products.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object used to send all products data.
 * @returns {Response} - A response with all products data or an error message.
 * @throws {Error} - If there is an error retrieving the products.
 */
export const getAllProducts = async (req: Request, res: Response) => {
    try {
        const shops = await get();
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function getFreeProduct
 * @description Retrieves all products that are not yet assigned to a section of a store.
 *
 * @param {Request} req - The Express request object containing the shop ID as a URL parameter.
 * @param {Response} res - The Express response object used to send the free products data.
 * @returns {Response} - A response with free products data or an error message.
 * @throws {Error} - If there is an error retrieving the free products.
 */
export const getFreeProduct = async (req: Request, res: Response) => {
    try {
        const shops = await getFree(parseInt(req.params.id));
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function getAllProductByShopP
 * @description Retrieves all products by shop ID.
 *
 * @param {Request} req - The Express request object containing the shop ID as a URL parameter.
 * @param {Response} res - The Express response object used to send the products data.
 * @returns {Response} - A response with all products data by shop or an error message.
 * @throws {Error} - If there is an error retrieving the products.
 */
export const getAllProductByShopP = async (req: Request, res: Response) => {
    try {
        const shops = await getAllProductByShop(parseInt(req.params.id));
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function addNewProductToRayonP
 * @description Adds a new product to a specified rayon (store section).
 *
 * @param {Request} req - The Express request object containing store ID, product ID, and name in the body.
 * @param {Response} res - The Express response object used to send the updated store data.
 * @returns {Response} - A response with the updated store data or an error message.
 * @throws {Error} - If there is an error adding the product to the rayon.
 */
export const addNewProductToRayonP = async (req: Request, res: Response) => {
    try {
        const {storeId, productId, name} = req.body;
        const shops = await addNewProductToRayon(storeId, productId, name);
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function getProductsBySectionNameP
 * @description Retrieves products by section name.
 *
 * @param {Request} req - The Express request object containing the section name as a URL parameter.
 * @param {Response} res - The Express response object used to send the products data.
 * @returns {Response} - A response with the products data by section name or an error message.
 * @throws {Error} - If there is an error retrieving the products by section name.
 */
export const getProductsBySectionNameP = async (req: Request, res: Response) => {
    try {
        const name = req.params.id;
        const shops = await getProductsBySectionName(name);
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}


/**
 * @function getSectionByProductIdP
 * @description Retrieves the section of a product by its ID.
 *
 * @param {Request} req - The Express request object containing the product ID as a URL parameter.
 * @param {Response} res - The Express response object used to send the section data.
 * @returns {Response} - A response with the section data of the product or an error message.
 * @throws {Error} - If there is an error retrieving the section of the product.
 */
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
