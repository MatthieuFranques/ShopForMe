export interface ProductModel {
    id: number;
    name: string;
    category: string;
    createdAt: Date;
    updatedAt: Date | null;
    deletedAt: Date | null;
    storeId: number | null;
}

export interface CreateProductDto {
    name: string;
    category: string;
}