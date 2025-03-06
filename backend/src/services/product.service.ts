/**
 * @module Services/Product
 * @description This module is responsible for handling product creation, retrieval, and updating.
 */
import prisma from "../utils/prisma";
import {CreateProductDto, ProductModel} from "../models/product.model";


/**
 * @function getOne
 * @description Retrieves a product by its ID.
 * 
 * @param {number} id - The ID of the product to retrieve.
 * @returns {Promise<ProductModel | null>} - The product if found, or null if not.
 * @throws {Error} - If an error occurs during the query.
 */
export async function getOne(id: number): Promise<ProductModel | null> {
    try {
        return await prisma.product.findUnique({
            where: {
                id: id
            }
        });
    } catch (error) {
        throw error;
    }
}

/**
 * @function update
 * @description Updates a product by its ID with the provided data.
 * 
 * @param {number} id - The ID of the product to update.
 * @param {Partial<CreateProductDto>} shop - The partial data to update the product.
 * @returns {Promise<ProductModel | null>} - The updated product if successful.
 * @throws {Error} - If an error occurs during the update.
 */
export async function update(id: number, shop: Partial<CreateProductDto>): Promise<ProductModel | null> {
    try {
        return await prisma.product.update({
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
 * @function create
 * @description Create a new product in the database.
 * 
 * @param {CreateProductDto} shop - The data for the new product.
 * @returns {Promise<ProductModel>} - The newly created product.
 * @throws {Error} - If an error occurs during creation.
 */
export async function create(shop: CreateProductDto) {

    try {
        return await prisma.product.create({
            data: {...shop}
        })
    } catch (e) {
        // console.log(e)
        throw e;
    }
}

/**
 * @function get
 * @description Fetch all products in the database.
 * 
 * @returns {Promise<ProductModel[] | null>} - An array of products, or null if none found.
 * @throws {Error} - If an error occurs during the query.
 */
export async function get(): Promise<ProductModel[] | null> {
    try {
        return await prisma.product.findMany();
    } catch (error) {
        // console.error(error);
        throw error;
    }
}

/**
 * @function getFree
 * @description Fetch all products that are not yet assigned to a section of a store.
 * 
 * @param {number} storeId - The ID of the store.
 * @returns {Promise<ProductModel[] | null>} - An array of products, or null if none are free.
 * @throws {Error} - If an error occurs during the query.
 */
export async function getFree(storeId: number): Promise<ProductModel[] | null> {
    try {
        return await prisma.product.findMany({
            where: {
                sections: {
                    none: {
                        storeId
                    },
                },
            },
        });
    } catch (error) {
        throw error;
    }
}

/**
 * @function getAllProductByShop
 * @description Fetch all products associated with a specific store.
 * 
 * @param {number} storeId - The ID of the store.
 * @returns {Promise<any>} - The list of products, with their section information.
 * @throws {Error} - If an error occurs during the query.
 */
export async function getAllProductByShop(storeId: number): Promise<any> {
    try {

        const products = await prisma.product.findMany({
            where: {
                sections: {
                    some: {
                        storeId: storeId,
                    },
                },
            },
            include: {
                sections: {
                    where: {
                        storeId: storeId,
                    },
                },
            },
        });

        return products.map(product => ({
            ...product,
            rayon: product.sections.length > 0 ? product.sections[0].name : null,
            sections: undefined,
        }));

    } catch (error) {
        throw error;
    }
}

/**
 * @function addNewProductToRayon
 * @description Add a new product to a specific section of a store.
 * 
 * @param {number} storeId - The ID of the store.
 * @param {number} productId - The ID of the product to add.
 * @param {string} name - The name of the section.
 * @returns {Promise<any>} - The created section.
 * @throws {Error} - If an error occurs during the creation.
 */
export async function addNewProductToRayon(storeId: number, productId: number, name: string): Promise<any> {
    return prisma.section.create({
        data: {
            name,
            price: 0,
            store: {
                connect: {id: storeId},
            },
            product: {
                connect: {id: productId},
            },
        },
    });
}

/**
 * @function getProductsBySectionName
 * @description Fetch products associated with a specific section by section name.
 * 
 * @param {string} sectionName - The name of the section to search for.
 * @returns {Promise<any[]>} - An array of sections with their associated products.
 * @throws {Error} - If an error occurs during the query.
 */
export async function getProductsBySectionName(sectionName: string) {
    try {
        // Rechercher une section par son nom et inclure les produits associés
        const section = await prisma.section.findMany({
            where: {
                name: sectionName,
            },
            include: {
                product: true, // Inclure les produits liés
            },
        });

        if (!section) {
            return []
        }

        // Retourner les produits associés
        return section;
    } catch (error) {
        // console.error('Error fetching products by section name:', error);
        throw error;
    }
}


/**
 * @function getSectionByProductId
 * @description Fetch the section associated with a specific product by product ID.
 * 
 * @param {number} productId - The ID of the product.
 * @returns {Promise<any | null>} - The section associated with the product, or null if not found.
 * @throws {Error} - If an error occurs during the query.
 */
export async function getSectionByProductId(productId: number) {
    try {
        const section = await prisma.section.findFirst({
            where: {
                productId: productId
            }
        });
        if (!section) {
            return []
        }

        return section;
    }
    catch (error) {
        throw error;
    }
}

