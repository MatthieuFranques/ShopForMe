import { getUserById, getUserByEmail } from "../../services/user.service";
import prisma from "../../utils/prisma";

jest.mock("../../utils/prisma", () => ({
    user: {
        findUnique: jest.fn(),
    },
}));

describe("User Service", () => {
    afterEach(() => {
        jest.clearAllMocks();
    });

    describe("getUserById", () => {
        it("should return a user when found", async () => {
            const mockUser = { id: 1, email: "test@example.com", password: "hashedpassword" };
            (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);

            const result = await getUserById(1);

            expect(prisma.user.findUnique).toHaveBeenCalledWith({ where: { id: 1 } });
            expect(result).toEqual(mockUser);
        });

        it("should return null if user is not found", async () => {
            (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);

            const result = await getUserById(99);

            expect(prisma.user.findUnique).toHaveBeenCalledWith({ where: { id: 99 } });
            expect(result).toBeNull();
        });

        it("should throw an error if Prisma fails", async () => {
            (prisma.user.findUnique as jest.Mock).mockRejectedValue(new Error("DB Error"));

            await expect(getUserById(1)).rejects.toThrow("DB Error");
        });
    });

    describe("getUserByEmail", () => {
        it("should return a user when found", async () => {
            const mockUser = { id: 1, email: "test@example.com", password: "hashedpassword" };
            (prisma.user.findUnique as jest.Mock).mockResolvedValue(mockUser);

            const result = await getUserByEmail("test@example.com");

            expect(prisma.user.findUnique).toHaveBeenCalledWith({ where: { email: "test@example.com" } });
            expect(result).toEqual(mockUser);
        });

        it("should return null if user is not found", async () => {
            (prisma.user.findUnique as jest.Mock).mockResolvedValue(null);

            const result = await getUserByEmail("notfound@example.com");

            expect(prisma.user.findUnique).toHaveBeenCalledWith({ where: { email: "notfound@example.com" } });
            expect(result).toBeNull();
        });

        it("should throw an error if Prisma fails", async () => {
            (prisma.user.findUnique as jest.Mock).mockRejectedValue(new Error("DB Error"));

            await expect(getUserByEmail("test@example.com")).rejects.toThrow("DB Error");
        });
    });
});
