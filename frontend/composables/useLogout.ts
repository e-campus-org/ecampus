export default function useLogout() {
    const accessToken = useCookie<string>("access_token", { watch: true });
    return () => {
        accessToken.value = "";
        navigateTo({ name: "auth" });
    };
}
