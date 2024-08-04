import { defineStore } from "pinia";
import { ref } from "vue";
import { isTokenStillFresh, parseJWT } from "@/helpers/jwt";

export const useAccountStore = defineStore("e-campus-account", () => {
    const accessToken = ref<string | null>(null);
    const refreshToken = ref<string | null>(null);

    const isLoggedIn = computed(() => accessToken.value && isTokenStillFresh(accessToken.value));

    const accountInfo = computed<JWT.Payload | null>(() => {
        if (accessToken.value) {
            return parseJWT(accessToken.value);
        } else {
            return null;
        }
    });

    return {
        accessToken,
        refreshToken,
        isLoggedIn,
        accountInfo
    };
});
