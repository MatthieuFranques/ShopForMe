import prisma from "../utils/prisma";
import {CreateShopDto, ShopModel} from "../models/shop.model";

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


export async function getAllShops(): Promise<ShopModel[] | null> {
    try {
        return await prisma.store.findMany();
    } catch (error) {
        // console.error(error);
        throw error;
    }
}