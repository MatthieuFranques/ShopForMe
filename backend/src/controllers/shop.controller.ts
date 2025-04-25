/**
 * @module Controllers/Shop
 * @description This module is responsible for handling shop creation, retrieval, and updating.
 */
import { Request, Response } from "express";
import { createShop, getShopById, updateShop, getAllShops, deleteShop } from "../services/shop.service";


/**
 * @function getShopByIdC
 * @description Retrieves a shop by its ID.
 *
 * @param {Request} req - The Express request object containing the shop ID as a URL parameter.
 * @param {Response} res - The Express response object used to send the shop data.
 * @returns {Response} - A response with the shop data or an error message.
 * @throws {Error} - If there is an error retrieving the shop.
 */
export const getShopByIdC = async (req: Request, res: Response) => {
    try {
        const shop = await getShopById(parseInt(req.params.id));
        return res.status(200).json(shop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function updateShopC
 * @description Updates a shop by its ID with the provided data.
 *
 * @param {Request} req - The Express request object containing the shop ID and update data in the body.
 * @param {Response} res - The Express response object used to send the updated shop data.
 * @returns {Response} - A response with the updated shop data or an error message.
 * @throws {Error} - If there is an error updating the shop.
 */
export const updateShopC = async (req: Request, res: Response) => {
    try {
        const updatedShop = await updateShop(parseInt(req.params.id), req.body);
        return res.status(200).json(updatedShop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function removeShopC
 * @description Deletes a shop by its ID.
 *
 * @param {Request} req - The Express request object containing the shop ID as a URL parameter.
 * @param {Response} res - The Express response object used to send the deletion confirmation.
 * @returns {Response} - A response indicating whether the shop was deleted or an error message.
 * @throws {Error} - If there is an error deleting the shop.
 */
export const removeShopC = async (req: Request, res: Response) => {
    try {
        const updatedShop = await deleteShop(parseInt(req.params.id));
        return res.status(200).json(updatedShop);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function createShopC
 * @description Creates a new shop using the data provided in the request body.
 *
 * @param {Request} req - The Express request object containing the new shop data in the body.
 * @param {Response} res - The Express response object used to send the created shop data.
 * @returns {Response} - A response with the newly created shop or an error message.
 * @throws {Error} - If there is an error creating the shop.
 */
export const createShopC = async (req: Request, res: Response) => {
    try {
        const shop = await createShop(req.body)
        return res.status(201).json(shop)
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}

/**
 * @function getAllShopsC
 * @description Retrieves all shops.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object used to send all shops data.
 * @returns {Response} - A response with all shops data or an error message.
 * @throws {Error} - If there is an error retrieving the shops.
 */
export const getAllShopsC = async (req: Request, res: Response) => {
    try {
        const shops = await getAllShops();
        return res.status(200).json(shops);
    } catch (error) {
        return res.status(500).json({message: "Internal Server Error", error});
    }
}
