/**
 * Represents a product in the system.
 */
export interface ProductModel {
    /**
     * The unique identifier of the product.
     */
    id: number;

    /**
     * The name of the product.
     */
    name: string;

    /**
     * The category under which the product falls.
     */
    category: string;

    /**
     * The date and time when the product was created.
     */
    createdAt: Date;

    /**
     * The date and time when the product was last updated.
     * Can be `null` if the product has not been updated since creation.
     */
    updatedAt: Date | null;

    /**
     * The date and time when the product was deleted.
     * Can be `null` if the product has not been deleted.
     */
    deletedAt: Date | null;
}

/**
 * Data transfer object (DTO) for creating a new product.
 */
export interface CreateProductDto {
    /**
     * The name of the product to be created.
     */
    name: string;

    /**
     * The category of the product to be created.
     */
    category: string;
}
