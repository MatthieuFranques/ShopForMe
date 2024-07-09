export interface CompleteUser {
    id: number;
    email: string;
    password: string;
    createdAt: Date;
    updatedAt: Date | null;
    deletedAt: Date | null;
}

export interface ReturnUser {
    id: number;
    email: string;
}

export interface EmailUser {
    email: string;
}

