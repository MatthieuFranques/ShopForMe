import { isValidEmail } from "../../utils/email";
import prisma from "../../utils/prisma";

jest.mock('../../utils/prisma', () => ({
    user: {
        findFirst: jest.fn()
    }
}));

describe('isValidEmail', () => {
    it('should return true for a valid email', async () => {
        (prisma.user.findFirst as jest.Mock).mockResolvedValue(null);

        const email ="test@example.com";
        const result = await isValidEmail(email);

        expect(result).toBe(true);
    });

    it('should return false for an invalid email', async () => {
        (prisma.user.findFirst as jest.Mock).mockResolvedValue({email: "test@example.com"});
        const email ="test@example.com";
        const result = await isValidEmail(email);

        expect(result).toBe(false);
    });

});