export async function useAccount(forceRefresh?: boolean) {
    const { accountInfo } = useJwt();

    const loading = computed(() => status.value === "pending");

    const { data: account, status } = await useAsyncData(
        "current-account",
        () => {
            if (accountInfo.value) {
                return useFetch<Accounts.ReadAccountDTO>(`/accounts/${accountInfo.value?.id}`, {}, !forceRefresh);
            } else {
                return Promise.resolve(null);
            }
        },
        {
            server: false,
            watch: [accountInfo]
        }
    );

    return { loading, account };
}
