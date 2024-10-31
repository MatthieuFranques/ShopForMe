import {api} from "../utils/utils";

export const productService = {

    getUserProduct: (storeId: number) => {
        return api("GET", `product/getFree/${storeId}`)
    }
}