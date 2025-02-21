import { completeUserToCreateUser } from "../../models/userDto";
import { CompleteUser, ReturnUser } from "../../models/user";

describe("completeUserToCreateUser", () => {
    it("should return a ReturnUser object with only id and email", () => {
        const mockCompleteUser: CompleteUser = {
            id: 1,
            email: "test@example.com",
            password: "hashedpassword",
            createdAt: new Date(),
            updatedAt: null,
            deletedAt: null
        };

        const expectedReturnUser: ReturnUser = {
            id: 1,
            email: "test@example.com",
        };

        const result = completeUserToCreateUser(mockCompleteUser);

        expect(result).toEqual(expectedReturnUser);
    });

    it("should not include additional fields like password", () => {
        const mockCompleteUser: CompleteUser = {
            id: 2,
            email: "user@example.com",
            password: "secret",
            createdAt: new Date(),
            updatedAt: null,
            deletedAt: null
        };

        const result = completeUserToCreateUser(mockCompleteUser);

        expect(result).not.toHaveProperty("password");
        expect(result).not.toHaveProperty("createdAt");
    });
});
