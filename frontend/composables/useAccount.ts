export function useAccount(forceRefresh?: boolean) {
    const { accountInfo } = useJwt();

    const loading = ref(false);
    const account = ref<Accounts.ReadAccountDTO | null>(null);

    (async () => {
        const { data, status } = await useAsyncData(
            "current-account",
            () => useFetch<Accounts.ReadAccountDTO>(`/accounts/${accountInfo.value?.id}`, {}, !forceRefresh),
            {
                server: false,
                watch: [accountInfo]
            }
        );

        watch(status, newVal => (loading.value = newVal === "pending"));

        watch(data, newVal => (account.value = newVal));
    })();

    return { loading, account };
}
