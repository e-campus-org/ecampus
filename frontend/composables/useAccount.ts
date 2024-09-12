export async function useAccount() {
    const { accountInfo } = useJwt();

    const loading = computed(() => status.value === "pending");

    const { data: account, status } = await useAsyncData(
        "current-account",
        () => {
            if (accountInfo.value) {
                return useFetch<Accounts.ReadAccountDTO>(`/accounts/${accountInfo.value?.id}`, {});
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
