/**
 * Communication API
 * @param method GET, POST, PUT, DELETE
 * @param url
 * @param body
 */
export const api = (
    method: "GET" | "POST" | "PUT" | "DELETE",
    url: string,
    body: any = null
) => {

    const apiUrl = window.location.protocol + "//" + window.location.hostname + ":9000/";

    return fetch(apiUrl + url, {
        method: method,
        body: body ? JSON.stringify(body) : null,
        cache: "no-cache",
        headers: {
            Accept: "*/*",
            "Content-Type": "application/json",
        },
    })
        .then((response) => {
            return response.json();
        })
};

/**
 * Log error
 * @param data message error
 */
export const onError = (data: any) => {
    console.error(data);
};