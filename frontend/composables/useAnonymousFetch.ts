import { StorageSerializers } from "@vueuse/core";

export async function useAnonymousFetch<T>(where: string, params: any, cache = false) {
    const config = useRuntimeConfig();
    const url = `${config.public.apiUrl}${where}`;
    if (cache) {
        const cached = useSessionStorage<T>(url, null, {
            serializer: StorageSerializers.object
        });
        if (!cached.value) {
            cached.value = await $fetch(url, params);
        }
        return cached.value;
    } else {
        return await $fetch(url, params);
    }
}
