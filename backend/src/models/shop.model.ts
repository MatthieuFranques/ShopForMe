export interface ShopModel {
    id: number;
    name: string;
    ville: string;
    adresse: string;
    layout: any;
    createdAt: Date;
    updatedAt: Date | null;
    deletedAt: Date | null;
}

export interface CreateShopDto {
    name: string;
    ville: string;
    adresse: string;
}