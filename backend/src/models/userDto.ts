import { CompleteUser, ReturnUser } from "./user";

/**
 * Transforms a complete user object to a simplified version with only the necessary details.
 * 
 * @param completeUser - The complete user object containing sensitive information.
 * @returns A simplified user object with only the id and email.
 */
export function completeUserToCreateUser(completeUser: CompleteUser): ReturnUser {
    return {
        id: completeUser.id,
        email: completeUser.email
    }
}
