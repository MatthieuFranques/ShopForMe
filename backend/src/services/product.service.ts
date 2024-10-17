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
        console.log(error);
        throw error;
    }
}

export async function create(shop: CreateProductDto) {

    try {
        return await prisma.product.create({
            data: {...shop}
        })
    } catch (e) {
        console.log(e)
        throw e;
    }
}


export async function get(): Promise<ProductModel[] | null> {
    try {
        return await prisma.product.findMany();
    } catch (error) {
        console.error(error);
        throw error;
    }
}