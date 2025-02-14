import bcrypt from 'bcryptjs';
import prisma from "../../utils/prisma";
import { createUser, getByEmailAndPwd } from '../../services/auth.service';

jest.mock("../../utils/prisma", () => ({
    user: {
        create: jest.fn(),
        findFirst: jest.fn(),
    }
}));

describe("AUth Service", () => {
    describe("createUser", () => {
        it("should create a new user", async () => {
            const mockUser= {email:"test@example.com", password:"hashedPassword"};
            (prisma.user.create as jest.Mock).mockResolvedValue(mockUser);

            const user = await createUser(mockUser.email, mockUser.password);
            expect(user).toEqual(mockUser);
            expect(prisma.user.create).toHaveBeenCalledWith({
                data: {
                    email: mockUser.email,
                    password: mockUser.password
                }
            });
        });

        it("Should throw an error if Prisma fails", async () => {
            (prisma.user.create as jest.Mock).mockRejectedValue(new Error("DB Error"));

            await expect(createUser("test@example.com", "hashedPassword")).rejects.toThrow("DB Error");
        });
    });

    describe("getByEmailAndPwd", () => {
        it("should return a user by email and password", async () => {
            const mockUser= {email:"test@example.com", password: await bcrypt.hash("password", 10)};

            (prisma.user.findFirst as jest.Mock).mockResolvedValue(mockUser);
            const user = await getByEmailAndPwd(mockUser.email, "password");

            expect(user).toEqual(mockUser);
            expect(prisma.user.findFirst).toHaveBeenCalledWith({
                where: {
                    email: mockUser.email
                }
            });
        });

        it("should return null if user is not found", async () => {
            (prisma.user.findFirst as jest.Mock).mockResolvedValue(null);

            const user = await getByEmailAndPwd("notfound@example.com", "password");

            expect(user).toBeNull();

        });

        it("should throw an error if Prisma fails", async () => {
            (prisma.user.findFirst as jest.Mock).mockRejectedValue(new Error("DB Error"));

            await expect(getByEmailAndPwd("test@example.com", "password")).rejects.toThrow("DB Error");

        })
    })
})
