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
    const port = process.env.REACT_APP_API_PORT
    const apiUrl = window.location.protocol + "//" + window.location.hostname + ":" + port + "/";
    const apiKey = "BjlsqduOAEJRORIUR738JDQJndqjJD"
    const requestHeaders = new Headers();
    requestHeaders.set("Accept", "*/*");
    requestHeaders.set("Content-Type", "application/json");
    requestHeaders.set("x-api-key", apiKey);

    console.log(apiKey)
    return fetch(apiUrl + url, {
        method: method,
        body: body ? JSON.stringify(body) : null,
        cache: "no-cache",
        headers: requestHeaders,
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