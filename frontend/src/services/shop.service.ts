import {api} from "../utils/utils";

export const ShopService = {

    getAllShop: () => {
        return api("GET", `shops`)
    },

    createShop: (fromData: any) => {
        return api("POST", `shops`, fromData)
    },

    getPlanById: (id: string | undefined) => {
        return api("GET", `shops/${id}`)
    },

    updatePlan: (id: number, body: any) => {
        return api("PUT", `shops/${id}`, body);
    },

    removePlan: (id: number) => {
        return api("DELETE", `shops/${id}`);
    },
}