import prisma from "../../utils/prisma";
import { 
    getOne, update, create, get, getFree, 
    getAllProductByShop, addNewProductToRayon, 
    getProductsBySectionName 
} from "../../services/product.service";
import { CreateProductDto, ProductModel } from "../../models/product.model";

// Mock Prisma
jest.mock("../../utils/prisma", () => ({
    product: {
        findUnique: jest.fn(),
        update: jest.fn(),
        create: jest.fn(),
        findMany: jest.fn(),
    },
    section: {
        create: jest.fn(),
        findMany: jest.fn(),
    }
}));

describe("Product Service", () => {

    describe("getOne", () => {
        it("should return a product if found", async () => {
            const mockProduct: ProductModel = { id: 1, name: "Product A" } as ProductModel;
            (prisma.product.findUnique as jest.Mock).mockResolvedValue(mockProduct);

            const result = await getOne(1);
            expect(result).toEqual(mockProduct);
            expect(prisma.product.findUnique).toHaveBeenCalledWith({ where: { id: 1 } });
        });

        it("should return null if product is not found", async () => {
            (prisma.product.findUnique as jest.Mock).mockResolvedValue(null);
            const result = await getOne(99);
            expect(result).toBeNull();
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.product.findUnique as jest.Mock).mockRejectedValue(new Error("DB Error"));
            await expect(getOne(1)).rejects.toThrow("DB Error");
        });
    });

    describe("update", () => {
        it("should update a product and return it", async () => {
            const mockProduct: ProductModel = { id: 1, name: "Updated Product" } as ProductModel;
            (prisma.product.update as jest.Mock).mockResolvedValue(mockProduct);

            const result = await update(1, { name: "Updated Product" });
            expect(result).toEqual(mockProduct);
        });

        it("should throw an error if update fails", async () => {
            (prisma.product.update as jest.Mock).mockRejectedValue(new Error("DB Error"));
            await expect(update(1, { name: "Fail" })).rejects.toThrow("DB Error");
        });
    });

    describe("create", () => {
        it("should create a new product", async () => {
            const mockProduct: ProductModel = { id: 1, name: "New Product" } as ProductModel;
            (prisma.product.create as jest.Mock).mockResolvedValue(mockProduct);

            const result = await create({
                name: "New Product",
                category: ""
            });
            expect(result).toEqual(mockProduct);
        });

        it("should throw an error if create fails", async () => {
            (prisma.product.create as jest.Mock).mockRejectedValue(new Error("DB Error"));
            await expect(create({ name: "Fail", category: "" })).rejects.toThrow("DB Error");
        });
    });

    describe("get", () => {
        it("should return all products", async () => {
            const mockProducts: ProductModel[] = [
                { id: 1, name: "Product A" } as ProductModel,
                { id: 2, name: "Product B" } as ProductModel
            ];
            (prisma.product.findMany as jest.Mock).mockResolvedValue(mockProducts);

            const result = await get();
            expect(result).toEqual(mockProducts);
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.product.findMany as jest.Mock).mockRejectedValue(new Error("DB Error"));
            await expect(get()).rejects.toThrow("DB Error");
        });
    });

    describe("getFree", () => {
        it("should return products not assigned to a section", async () => {
            const mockProducts: ProductModel[] = [{ id: 1, name: "Free Product" } as ProductModel];
            (prisma.product.findMany as jest.Mock).mockResolvedValue(mockProducts);

            const result = await getFree(1);
            expect(result).toEqual(mockProducts);
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.product.findMany as jest.Mock).mockRejectedValue(new Error("DB Error"));
            await expect(getFree(1)).rejects.toThrow("DB Error");
        });
    });

    describe("getAllProductByShop", () => {
        it("should return all products by shop with rayon name", async () => {
            const mockProducts = [
                { id: 1, name: "Product A", sections: [{ name: "Rayon 1" }] },
                { id: 2, name: "Product B", sections: [] },
            ];
            (prisma.product.findMany as jest.Mock).mockResolvedValue(mockProducts);

            const result = await getAllProductByShop(1);
            expect(result).toEqual([
                { id: 1, name: "Product A", rayon: "Rayon 1" },
                { id: 2, name: "Product B", rayon: null }
            ]);
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.product.findMany as jest.Mock).mockRejectedValue(new Error("DB Error"));
            await expect(getAllProductByShop(1)).rejects.toThrow("DB Error");
        });
    });

    describe("addNewProductToRayon", () => {
        it("should create a new section and link a product", async () => {
            const mockSection = { id: 1, name: "Rayon A", storeId: 1, productId: 1 };
            (prisma.section.create as jest.Mock).mockResolvedValue(mockSection);

            const result = await addNewProductToRayon(1, 1, "Rayon A");
            expect(result).toEqual(mockSection);
        });
    });

    describe("getProductsBySectionName", () => {
        it("should return products by section name", async () => {
            const mockSections = [
                { name: "Rayon A", product: [{ id: 1, name: "Product A" }] }
            ];
            (prisma.section.findMany as jest.Mock).mockResolvedValue(mockSections);

            const result = await getProductsBySectionName("Rayon A");
            expect(result).toEqual(mockSections);
        });

        it("should return an empty array if no products are found", async () => {
            (prisma.section.findMany as jest.Mock).mockResolvedValue([]);
            const result = await getProductsBySectionName("Rayon A");
            expect(result).toEqual([]);
        });

        it("should return an empty array if no section is found", async () => {
            (prisma.section.findMany as jest.Mock).mockResolvedValue([]);
            const result = await getProductsBySectionName("Rayon A");
            expect(result).toEqual([]);
        });

        it("should throw an error if an exception occurs", async () => {
            (prisma.section.findMany as jest.Mock).mockRejectedValue(new Error("DB Error"));
            await expect(getProductsBySectionName("Rayon A")).rejects.toThrow("DB Error");
        });
    });

});
