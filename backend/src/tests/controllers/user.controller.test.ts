import { Request, Response } from "express";
import { getUser } from "../../controllers/user.controller";
import { getUserByEmail, getUserById } from "../../services/user.service";
import { CompleteUser } from "../../models/user";

jest.mock("../../services/user.service");

describe("User Controller", () => {
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

    describe("getUser", () => {
        it("should return a user by id", async () => {
            const user: CompleteUser = {
                id: 1,
                email: "test@example.com",
                // name: "Test User",
                password: "password123",
                createdAt: new Date(),
                updatedAt: new Date(),
                deletedAt: null
            };
            (getUserById as jest.Mock).mockResolvedValue(user);
            req.query = { params: "id", value: "1" };

            await getUser(req as Request, res as Response);

            expect(getUserById).toHaveBeenCalledWith(1);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({ message: "User found", user });
        });

        it("should return a user by email", async () => {
            const user: CompleteUser = {
                id: 1,
                email: "test@example.com",
                // name: "Test User",
                password: "password123",
                createdAt: new Date(),
                updatedAt: new Date(),
                deletedAt: null
            };
            (getUserByEmail as jest.Mock).mockResolvedValue(user);
            req.query = { params: "email", value: "test@example.com" };

            await getUser(req as Request, res as Response);

            expect(getUserByEmail).toHaveBeenCalledWith("test@example.com");
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({ message: "User found", user });
        });

        it("should return 400 if query parameters are invalid", async () => {
            req.query = { params: "", value: "" };

            await getUser(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({ message: "Invalid query parameters" });
        });

        it("should return 404 if user is not found", async () => {
            (getUserById as jest.Mock).mockResolvedValue(null);
            req.query = { params: "id", value: "1" };

            await getUser(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(404);
            expect(res.json).toHaveBeenCalledWith({ message: "User not found" });
        });

        it("should return 500 if there is an error", async () => {
            (getUserById as jest.Mock).mockRejectedValue(new Error("Internal Server Error"));
            req.query = { params: "id", value: "1" };

            await getUser(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error" });
        });
    });
});