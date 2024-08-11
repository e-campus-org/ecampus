export function useNuxtLoading() {
    const nuxtLoading = ref(true);

    const nuxtApp = useNuxtApp();

    nuxtApp.hook("page:finish", () => {
        nuxtLoading.value = false;
    });

    return nuxtLoading;
}
