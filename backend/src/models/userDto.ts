import { CompleteUser, ReturnUser } from "./user";

export function completeUserToCreateUser(completeUser: CompleteUser): ReturnUser {
    return {
        id: completeUser.id,
        email: completeUser.email
    }
}