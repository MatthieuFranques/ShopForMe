import prisma from "../utils/prisma";
import {CreateProductDto, ProductModel} from "../models/product.model";

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

export async function get(): Promise<ProductModel[] | null> {
    try {
        return await prisma.product.findMany();
    } catch (error) {
        // console.error(error);
        throw error;
    }
}

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