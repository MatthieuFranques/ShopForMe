import {api} from "../utils/utils";

export const ProductService = {

    getUserProduct: (storeId: number) => {
        return api("GET", `product/getFree/${storeId}`)
    },

    createProduct: (body: any) => {
        return api("POST", `product/`, body)
    },

    addNewProductToRayonP: (body: any) => {
        return api("POST", `product/addNewProductToRayonP`, body)
    }
}