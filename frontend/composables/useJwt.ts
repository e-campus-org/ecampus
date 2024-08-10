import jwtDecode from "jwt-decode";

export function useJwt() {
    const accessToken = useCookie("access_token", {
        watch: true
    });

    const isFresh = computed(() => {
        if (accessToken.value) {
            if (payload.value) {
                return Math.floor(Date.now() / 1000) < new Date(payload.value.exp).getTime();
            } else {
                return false;
            }
        } else {
            return false;
        }
    });

    const payload = computed(() => {
        if (accessToken.value) {
            try {
                return jwtDecode<JWT.Payload>(accessToken.value);
            } catch {
                return null;
            }
        } else {
            return null;
        }
    });

    return {
        payload,
        isFresh
    };
}
