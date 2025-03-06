/**
 * Represents a shop in the system.
 */
export interface ShopModel {
    /**
     * The unique identifier of the shop.
     */
    id: number;

    /**
     * The name of the shop.
     */
    name: string;

    /**
     * The city where the shop is located.
     */
    ville: string;

    /**
     * The address of the shop.
     */
    adresse: string;

    /**
     * The layout of the shop. Can be any data type (e.g., JSON, object).
     * This might represent the internal structure or plan of the shop.
     */
    layout: any;

    /**
     * The date and time when the shop was created.
     */
    createdAt: Date;

    /**
     * The date and time when the shop was last updated.
     * Can be `null` if the shop has not been updated since creation.
     */
    updatedAt: Date | null;

    /**
     * The date and time when the shop was deleted.
     * Can be `null` if the shop has not been deleted.
     */
    deletedAt: Date | null;
}

/**
 * Data transfer object (DTO) for creating a new shop.
 */
export interface CreateShopDto {
    /**
     * The name of the shop to be created.
     */
    name: string;

    /**
     * The city where the shop will be located.
     */
    ville: string;

    /**
     * The address of the shop to be created.
     */
    adresse: string;
}
