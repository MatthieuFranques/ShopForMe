/**
 * Represents a complete user with sensitive information.
 */
export interface CompleteUser {
    /**
     * The unique identifier of the user.
     */
    id: number;

    /**
     * The email address of the user.
     */
    email: string;

    /**
     * The hashed password of the user.
     * This should be stored securely.
     */
    password: string;

    /**
     * The date and time when the user was created.
     */
    createdAt: Date;

    /**
     * The date and time when the user's information was last updated.
     * Can be `null` if the user has never been updated.
     */
    updatedAt: Date | null;

    /**
     * The date and time when the user was deleted.
     * Can be `null` if the user has not been deleted.
     */
    deletedAt: Date | null;
}

/**
 * A simplified version of a user, typically used for returning public user details.
 */
export interface ReturnUser {
    /**
     * The unique identifier of the user.
     */
    id: number;

    /**
     * The email address of the user.
     */
    email: string;
}

/**
 * Represents a user with just an email, used in email validation or querying.
 */
export interface EmailUser {
    /**
     * The email address of the user.
     */
    email: string;
}
