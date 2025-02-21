export interface ShopModelCreate {
    name: string;
    adresse: string;
    ville: string;
}

export interface ShopModel {
    name: string;
    adresse: string;
    ville: string;
    id: number;
    layout: any;
}