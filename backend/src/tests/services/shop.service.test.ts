import prisma from "../../utils/prisma";
import {
    getShopById,
    updateShop,
    deleteShop,
    createShop,
    getAllShops
} from "../../services/shop.service";
import { CreateShopDto, ShopModel } from "../../models/shop.model";

jest.mock("../../utils/prisma", () => ({
    store: {
        findUnique: jest.fn(),
        update: jest.fn(),
        delete: jest.fn(),
        create: jest.fn(),
        findMany: jest.fn()
    },
    section: {
        deleteMany: jest.fn()
    }
}));

describe("Shop Service", () => {
    describe("getShopById", () => {
        it("should return a shop if found", async () => {
            const mockShop: ShopModel = { id: 1, name: "Shop A" } as ShopModel;
            (prisma.store.findUnique as jest.Mock).mockResolvedValue(mockShop);

            const result = await getShopById(1);
            expect(result).toEqual(mockShop);
            expect(prisma.store.findUnique).toHaveBeenCalledWith({ where: { id: 1 } });
        });

        it("should return null if shop is not found", async () => {
            (prisma.store.findUnique as jest.Mock).mockResolvedValue(null);
            const result = await getShopById(99);
            expect(result).toBeNull();
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.store.findUnique as jest.Mock).mockRejectedValue(new Error("Test Error"));
            await expect(getShopById(1)).rejects.toThrow("Test Error");
        });
    });

    describe("updateShop", () => {
        it("should update a shop and return it", async () => {
            const mockShop: ShopModel = { id: 1, name: "Updated Shop" } as ShopModel;
            (prisma.store.update as jest.Mock).mockResolvedValue(mockShop);

            const result = await updateShop(1, { name: "Updated Shop" });
            expect(result).toEqual(mockShop);
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.store.update as jest.Mock).mockRejectedValue(new Error("Test Error"));
            await expect(updateShop(1, { name: "Updated Shop" })).rejects.toThrow("Test Error");
        });
    });

    describe("deleteShop", () => {
        it("should delete a shop and return it", async () => {
            const mockShop: ShopModel = { id: 1, name: "Deleted Shop" } as ShopModel;
            (prisma.section.deleteMany as jest.Mock).mockResolvedValue({ count: 2 });
            (prisma.store.delete as jest.Mock).mockResolvedValue(mockShop);

            const result = await deleteShop(1);
            expect(result).toEqual(mockShop);
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.section.deleteMany as jest.Mock).mockRejectedValue(new Error("Test Error"));
            await expect(deleteShop(1)).rejects.toThrow("Test Error");
        });
    });

    describe("createShop", () => {
        it("should create a new shop", async () => {
            const mockShop: ShopModel = { id: 1, name: "New Shop" } as ShopModel;
            (prisma.store.create as jest.Mock).mockResolvedValue(mockShop);

            const result = await createShop({ name: "New Shop" } as CreateShopDto);
            expect(result).toEqual(mockShop);
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.store.create as jest.Mock).mockRejectedValue(new Error("Test Error"));
            await expect(createShop({ name: "New Shop" } as CreateShopDto)).rejects.toThrow("Test Error");
        });
    });

    describe("getAllShops", () => {
        it("should return all shops", async () => {
            const mockShops: ShopModel[] = [
                { id: 1, name: "Shop A" } as ShopModel,
                { id: 2, name: "Shop B" } as ShopModel
            ];
            (prisma.store.findMany as jest.Mock).mockResolvedValue(mockShops);

            const result = await getAllShops();
            expect(result).toEqual(mockShops);
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.store.findMany as jest.Mock).mockRejectedValue(new Error("Test Error"));
            await expect(getAllShops()).rejects.toThrow("Test Error");
        });
    });
});
