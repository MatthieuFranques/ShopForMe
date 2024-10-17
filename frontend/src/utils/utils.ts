/**
 * Communication API
 * @param method GET, POST, PUT, DELETE
 * @param url
 * @param body
 * @param successCallback
 * @param errorCallback
 */
export const api = (
    method: "GET" | "POST" | "PUT" | "DELETE",
    url: string,
    body: any,
    successCallback: any,
    errorCallback: any
) => {

    fetch("http://localhost:8080/" + url, {
        method: method,
        body: JSON.stringify(body),
        cache: "no-cache",
        headers: {
            Accept: "*/*",
            "Content-Type": "application/json",
        },
    })
        .then((response) => {
            return response.json();
        })
        .then((data) => {
            successCallback(data);
        })
        .catch((error) => {
            errorCallback(error);
        });
};

/**
 * Log error
 * @param data message error
 */
export const onError = (data: any) => {
    console.error(data);
};