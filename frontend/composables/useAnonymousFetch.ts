import { StorageSerializers } from "@vueuse/core";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function useAnonymousFetch<T>(where: string, params: any, cache = false) {
    const config = useRuntimeConfig();
    const url = `${config.public.apiUrl}${where}`;
    if (cache) {
        const cached = useSessionStorage<T>(url, null, {
            serializer: StorageSerializers.object
        });
        if (!cached.value) {
            cached.value = await $fetch<T>(url, params);
        }
        return cached.value;
    } else {
        return await $fetch<T>(url, params);
    }
}
