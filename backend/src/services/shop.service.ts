/**
 * @module Services/Shop
 * @description This module is responsible for handling shop creation, retrieval, and updating.
 */
import prisma from "../utils/prisma";
import {CreateShopDto, ShopModel} from "../models/shop.model";

/**
 * @function getShopById
 * @description Fetch a shop by its ID.
 * 
 * @param {number} id - The ID of the shop.
 * @returns {Promise<ShopModel | null>} - The shop if found, or null if not.
 * @throws {Error} - If an error occurs during the query.
 */
export async function getShopById(id: number): Promise<ShopModel | null> {
    try {
        return await prisma.store.findUnique({
            where: {
                id: id
            }
        });
    } catch (error) {
        throw error;
    }
}

/**
 * @function updateShop
 * @description Update a shop by its ID with the given data.
 * 
 * @param {number} id - The ID of the shop to update.
 * @param {Partial<CreateShopDto>} shop - The partial data to update the shop.
 * @returns {Promise<ShopModel | null>} - The updated shop if successful.
 * @throws {Error} - If an error occurs during the update.
 */
export async function updateShop(id: number, shop: Partial<CreateShopDto>): Promise<ShopModel | null> {
    try {
        return await prisma.store.update({
            where: {
                id: id
            },
            data: shop
        });
    } catch (error) {
        // console.log(error);
        throw error;
    }
}

/**
 * @function deleteShop
 * @description Delete a shop by its ID and remove all related sections.
 * 
 * @param {number} id - The ID of the shop to delete.
 * @returns {Promise<ShopModel | null>} - The deleted shop if successful.
 * @throws {Error} - If an error occurs during deletion.
 */
export async function deleteShop(id: number): Promise<ShopModel | null> {
    try {

        await prisma.section.deleteMany({
            where: {
                storeId: id
            }
        })

        return await prisma.store.delete({
            where: {
                id: id
            },
        });
    } catch (error) {
        // console.error(error);
        throw error;
    }
}

/**
 * @function createShop
 * @description Create a new shop.
 * 
 * @param {CreateShopDto} shop - The data for the new shop.
 * @returns {Promise<ShopModel>} - The newly created shop.
 * @throws {Error} - If an error occurs during creation.
 */
export async function createShop(shop: CreateShopDto) {

    try {
        return await prisma.store.create({
            data: {...shop, layout: []}
        })
    } catch (e) {
        // console.log(e)
        throw e;
    }
}

/**
 * @function getAllShops
 * @description Fetch all shops in the database.
 * 
 * @returns {Promise<ShopModel[] | null>} - An array of shops, or null if none found.
 * @throws {Error} - If an error occurs during the query.
 */
export async function getAllShops(): Promise<ShopModel[] | null> {
    try {
        return await prisma.store.findMany();
    } catch (error) {
        // console.error(error);
        throw error;
    }
}