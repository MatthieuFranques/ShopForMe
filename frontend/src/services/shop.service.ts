import {api} from "../utils/utils";

export const ShopService = {

    getAllShop: () => {
        return api("GET", `shop`)
    },

    createShop: (fromData: any) => {
        return api("POST", `shop`, fromData)
    },

    getPlanById: (id: string | undefined) => {
        return api("GET", `shop/${id}`)
    },

    updatePlan: (id: number, body: any) => {
        return api("PUT", `shop/${id}`, body);
    },

    removePlan: (id: number) => {
        return api("DELETE", `shop/${id}`);
    },
}