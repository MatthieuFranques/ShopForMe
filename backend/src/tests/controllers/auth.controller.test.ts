import { Request, Response } from "express";
import { register, login } from "../../controllers/auth.controller";
import { isValidEmail } from "../../utils/email";
import bcrypt from 'bcryptjs';
import { createUser, getByEmailAndPwd } from "../../services/auth.service";
import { completeUserToCreateUser } from "../../models/userDto";
import { CompleteUser, ReturnUser } from "../../models/user";

jest.mock("../../utils/email");
jest.mock("bcryptjs");
jest.mock("../../services/auth.service");
jest.mock("../../models/userDto");

describe("Auth Controller", () => {
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

    describe("register", () => {
        it("should create a new user", async () => {
            const user: CompleteUser = {
                id: 1,
                email: "test@example.com",
                // name: "Test User",
                password: "hashedPassword",
                createdAt: new Date(),
                updatedAt: new Date(),
                deletedAt: null
            };
            // const returnUser: ReturnUser = { id: 1, email: "test@example.com", name: "Test User" };
            const returnUser: ReturnUser = { id: 1, email: "test@example.com"};
            (bcrypt.hash as jest.Mock).mockResolvedValue("hashedPassword");
            (isValidEmail as jest.Mock).mockResolvedValue(true);
            (createUser as jest.Mock).mockResolvedValue(user);
            (completeUserToCreateUser as jest.Mock).mockReturnValue(returnUser);
            req.body = { email: "test@example.com", password: "password" };

            await register(req as Request, res as Response);

            expect(bcrypt.hash).toHaveBeenCalledWith("password", 12);
            expect(isValidEmail).toHaveBeenCalledWith("test@example.com");
            expect(createUser).toHaveBeenCalledWith("test@example.com", "hashedPassword");
            expect(completeUserToCreateUser).toHaveBeenCalledWith(user);
            expect(res.status).toHaveBeenCalledWith(201);
            expect(res.json).toHaveBeenCalledWith({ message: "User created successfully", user: returnUser });
        });

        it("should return 400 if email is invalid", async () => {
            (isValidEmail as jest.Mock).mockResolvedValue(false);
            req.body = { email: "test@example.com", password: "password" };

            await register(req as Request, res as Response);

            expect(isValidEmail).toHaveBeenCalledWith("test@example.com");
            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({ message: "Email already exists" });
        });

        it("should return 400 if there is an error creating user", async () => {
            (bcrypt.hash as jest.Mock).mockResolvedValue("hashedPassword");
            (isValidEmail as jest.Mock).mockResolvedValue(true);
            (createUser as jest.Mock).mockRejectedValue(new Error("Error creating user"));
            req.body = { email: "test@example.com", password: "password" };

            await register(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({ message: "Error creating user" });
        });

        it("should return 500 if there is an internal server error", async () => {
            (bcrypt.hash as jest.Mock).mockResolvedValue("hashedPassword");
            (isValidEmail as jest.Mock).mockResolvedValue(true);
            (createUser as jest.Mock).mockRejectedValue({});
            req.body = { email: "test@example.com", password: "password" };

            await register(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error" });
        });
    });

    describe("login", () => {
        it("should log in a user", async () => {
            const user: CompleteUser = {
                id: 1,
                email: "test@example.com",
                // name: "Test User",
                password: "hashedPassword",
                createdAt: new Date(),
                updatedAt: new Date(),
                deletedAt: null
            };
            // const returnUser: ReturnUser = { id: 1, email: "test@example.com", name: "Test User" };
            const returnUser: ReturnUser = { id: 1, email: "test@example.com"};
            (getByEmailAndPwd as jest.Mock).mockResolvedValue(user);
            (completeUserToCreateUser as jest.Mock).mockReturnValue(returnUser);
            req.body = { email: "test@example.com", password: "password" };

            await login(req as Request, res as Response);

            expect(getByEmailAndPwd).toHaveBeenCalledWith("test@example.com", "password");
            expect(completeUserToCreateUser).toHaveBeenCalledWith(user);
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({ message: "User logged in successfully", user: returnUser });
        });

        it("should return 404 if email or password is invalid", async () => {
            (getByEmailAndPwd as jest.Mock).mockResolvedValue(null);
            req.body = { email: "test@example.com", password: "password" };

            await login(req as Request, res as Response);

            expect(getByEmailAndPwd).toHaveBeenCalledWith("test@example.com", "password");
            expect(res.status).toHaveBeenCalledWith(404);
            expect(res.json).toHaveBeenCalledWith({ message: "Invalid email or password" });
        });

        it("should return 404 if there is an error logging in user", async () => {
            (getByEmailAndPwd as jest.Mock).mockRejectedValue(new Error("Error logging in user"));
            req.body = { email: "test@example.com", password: "password" };

            await login(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(404);
            expect(res.json).toHaveBeenCalledWith({ message: "Error logging in user" });
        });

        it("should return 500 if there is an internal server error", async () => {
            (getByEmailAndPwd as jest.Mock).mockRejectedValue({});
            req.body = { email: "test@example.com", password: "password" };

            await login(req as Request, res as Response);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({ message: "Internal Server Error" });
        });
    });
});