import { Request, Response } from "express";
import {
    getProductById,
    updateProduct,
    createProduct,
    getAllProducts,
    getFreeProduct,
    getAllProductByShopP,
    addNewProductToRayonP,
    getProductsBySectionNameP
} from "../../controllers/product.controller";
import {
    create,
    get,
    getOne,
    update,
    getFree,
    getAllProductByShop,
    addNewProductToRayon
} from "../../services/product.service";

jest.mock("../../services/product.service");

describe("Product Controller", () => {
    let req: Partial<Request>;
    let res: Partial<Response>;

    beforeEach(() => {
        req = {};
        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
        };
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe("getProductById", () => {
        it("should return a product by id", async () => {
            const product = { id: 1, name: "Test Product" };
            (getOne as jest.Mock).mockResolvedValue(product);
            req.params = { id: "1" };

            await getProductById(req as Request, res as Response);

            expect(getOne).toHaveBeenCalledWith(1);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(product);
        });

        it("should return 500 if there is an error", async () => {
            (getOne as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.params = { id: "1" };

            await getProductById(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error" });
        });
    });

    describe("updateProduct", () => {
        it("should update a product", async () => {
            const updatedProduct = { id: 1, name: "Updated Product" };
            (update as jest.Mock).mockResolvedValue(updatedProduct);
            req.params = { id: "1" };
            req.body = { name: "Updated Product" };

            await updateProduct(req as Request, res as Response);

            expect(update).toHaveBeenCalledWith(1, req.body);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(updatedProduct);
        });

        it("should return 500 if there is an error", async () => {
            (update as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.params = { id: "1" };
            req.body = { name: "Updated Product" };

            await updateProduct(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    describe("createProduct", () => {
        it("should create a product", async () => {
            const newProduct = { id: 1, name: "New Product" };
            (create as jest.Mock).mockResolvedValue(newProduct);
            req.body = { name: "New Product" };

            await createProduct(req as Request, res as Response);

            expect(create).toHaveBeenCalledWith(req.body);
            expect(res.status).toHaveBeenCalledWith(201);
            expect(res.json).toHaveBeenCalledWith(newProduct);
        });

        it("should return 500 if there is an error", async () => {
            (create as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.body = { name: "New Product" };

            await createProduct(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    describe("getAllProducts", () => {
        it("should return all products", async () => {
            const products = [{ id: 1, name: "Product 1" }, { id: 2, name: "Product 2" }];
            (get as jest.Mock).mockResolvedValue(products);

            await getAllProducts(req as Request, res as Response);

            expect(get).toHaveBeenCalled();
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(products);
        });

        it("should return 500 if there is an error", async () => {
            (get as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));

            await getAllProducts(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    describe("getFreeProduct", () => {
        it("should return free products", async () => {
            const products = [{ id: 1, name: "Free Product 1" }];
            (getFree as jest.Mock).mockResolvedValue(products);
            req.params = { id: "1" };

            await getFreeProduct(req as Request, res as Response);

            expect(getFree).toHaveBeenCalledWith(1);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(products);
        });

        it("should return 500 if there is an error", async () => {
            (getFree as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.params = { id: "1" };

            await getFreeProduct(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    describe("getAllProductByShopP", () => {
        it("should return all products by shop", async () => {
            const products = [{ id: 1, name: "Product 1" }];
            (getAllProductByShop as jest.Mock).mockResolvedValue(products);
            req.params = { id: "1" };

            await getAllProductByShopP(req as Request, res as Response);

            expect(getAllProductByShop).toHaveBeenCalledWith(1);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(products);
        });

        it("should return 500 if there is an error", async () => {
            (getAllProductByShop as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.params = { id: "1" };

            await getAllProductByShopP(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    describe("addNewProductToRayonP", () => {
        it("should add a new product to rayon", async () => {
            const product = { id: 1, name: "Product 1" };
            (addNewProductToRayon as jest.Mock).mockResolvedValue(product);
            req.body = { storeId: 1, productId: 1, name: "Product 1" };

            await addNewProductToRayonP(req as Request, res as Response);

            expect(addNewProductToRayon).toHaveBeenCalledWith(1, 1, "Product 1");
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(product);
        });

        it("should return 500 if there is an error", async () => {
            (addNewProductToRayon as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.body = { storeId: 1, productId: 1, name: "Product 1" };

            await addNewProductToRayonP(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
        });
    });

    // describe("getProductsBySectionNameP", () => {
    //     it("should return all products by section name", async () => {
    //         const products = [{ id: 1, name: "Product 1" }];
    //         (get as jest.Mock).mockResolvedValue(products);
    //         req.params = { name: "Section 1" };

    //         await getProductsBySectionNameP(req as Request, res as Response);

    //         expect(get).toHaveBeenCalledWith("Section 1");
    //         expect(res.status).toHaveBeenCalledWith(200);
    //         expect(res.json).toHaveBeenCalledWith(products);
    //     });

    //     it("should return 500 if there is an error", async () => {
    //         (get as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
    //         req.params = { name: "Section 1" };

    //         await getProductsBySectionNameP(req as Request, res as Response);

    //         expect(res.status).toHaveBeenCalledWith(500);
    //         expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error", error: new Error("Internal Server Error") });
    //     });

    // });
});