import { Request, Response } from "express";
import { createShopC, getShopByIdC, updateShopC, removeShopC, getAllShopsC } from "../../controllers/shop.controller";
import { createShop, getShopById, updateShop, getAllShops, deleteShop } from "../../services/shop.service";

jest.mock("../../services/shop.service");

describe("Shop Controller", () => {
    let req: Partial<Request>;
    let res: Partial<Response>;

    beforeEach(() => {
        req = {};
        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
        };
        jest.fn();
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe("getShopByIdC", () => {
        it("should return a shop by id", async () => {
            const shop = { id: 1, name: "Test Shop" };
            (getShopById as jest.Mock).mockResolvedValue(shop);
            req.params = { id: "1" };

            await getShopByIdC(req as Request, res as Response);

            expect(getShopById).toHaveBeenCalledWith(1);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(shop);
        });

        it("should return 500 if there is an error", async () => {
            (getShopById as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.params = { id: "1" };

            await getShopByIdC(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error" });
        });
    });

    describe("updateShopC", () => {
        it("should update a shop", async () => {
            const updatedShop = { id: 1, name: "Updated Shop" };
            (updateShop as jest.Mock).mockResolvedValue(updatedShop);
            req.params = { id: "1" };
            req.body = { name: "Updated Shop" };

            await updateShopC(req as Request, res as Response);

            expect(updateShop).toHaveBeenCalledWith(1, req.body);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(updatedShop);
        });

        it("should return 500 if there is an error", async () => {
            (updateShop as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.params = { id: "1" };
            req.body = { name: "Updated Shop" };

            await updateShopC(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    describe("removeShopC", () => {
        it("should delete a shop", async () => {
            const deletedShop = { id: 1, name: "Deleted Shop" };
            (deleteShop as jest.Mock).mockResolvedValue(deletedShop);
            req.params = { id: "1" };

            await removeShopC(req as Request, res as Response);

            expect(deleteShop).toHaveBeenCalledWith(1);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(deletedShop);
        });

        it("should return 500 if there is an error", async () => {
            (deleteShop as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.params = { id: "1" };

            await removeShopC(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    describe("createShopC", () => {
        it("should create a shop", async () => {
            const newShop = { id: 1, name: "New Shop" };
            (createShop as jest.Mock).mockResolvedValue(newShop);
            req.body = { name: "New Shop" };

            await createShopC(req as Request, res as Response);

            expect(createShop).toHaveBeenCalledWith(req.body);
            expect(res.status).toHaveBeenCalledWith(201);
            expect(res.json).toHaveBeenCalledWith(newShop);
        });

        it("should return 500 if there is an error", async () => {
            (createShop as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.body = { name: "New Shop" };

            await createShopC(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    describe("getAllShopsC", () => {
        it("should return all shops", async () => {
            const shops = [{ id: 1, name: "Shop 1" }, { id: 2, name: "Shop 2" }];
            (getAllShops as jest.Mock).mockResolvedValue(shops);

            await getAllShopsC(req as Request, res as Response);

            expect(getAllShops).toHaveBeenCalled();
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(shops);
        });

        it("should return 500 if there is an error", async () => {
            (getAllShops as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));

            await getAllShopsC(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });
});