export interface CompleteUser {
    id: number;
    email: string;
    password: string;
    createdAt: Date;
    updatedAt: Date;
}

export interface CreateUser {
    id: number;
    email: string;
    password: string;
}

export interface EmailUser {
    email: string;
}

