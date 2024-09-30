// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function useFetch<T>(where: string, params: any) {
    const config = useRuntimeConfig();
    const accessToken = useCookie("access_token");
    const url = `${config.public.apiUrl}${where}`;

    params = params || {};
    if (accessToken) {
        params["headers"] = {
            Authorization: `Bearer ${accessToken.value}`
        };
    }
    return await $fetch<T>(url, params);
}
