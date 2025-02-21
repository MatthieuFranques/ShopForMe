import {api} from "../utils/utils";

export const ProductService = {

    getUserProduct: (storeId: number) => {
        return api("GET", `products/getFree/${storeId}`)
    },

    createProduct: (body: any) => {
        return api("POST", `products/`, body)
    },

    addNewProductToRayonP: (body: any) => {
        return api("POST", `products/addNewProductToRayonP`, body)
    },

    getProductsBySectionName: (name: any) => {
        return api("GET", `products/getProductsBySectionName/${name}`)
    }
}