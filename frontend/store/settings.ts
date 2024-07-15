import { defineStore } from "pinia";
import { ref } from "vue";
import { useI18n } from "vue-i18n";

export const useSettingsStore = defineStore(
    "e-campus-settings",
    () => {
        const i18n = useI18n();
        const locale = ref<Locale>("en");
        const isDarkThemeApplied = computed(
            () => colorMode.preference === "dark" || (colorMode.preference === "system" && colorMode.value === "dark")
        );
        const colorMode = useColorMode();

        function setLocale(value: Locale) {
            locale.value = value;
        }

        function switchTheme() {
            if (isDarkThemeApplied.value) {
                colorMode.preference = "light";
            } else {
                colorMode.preference = "dark";
            }
        }

        watch(locale, newValue => (i18n.locale.value = newValue as Locale));

        return {
            setLocale,
            locale,
            switchTheme,
            isDarkThemeApplied
        };
    },
    {
        persist: {
            key: "e-campus.settings",
            storage: persistedState.localStorage,
            paths: ["locale"]
        }
    }
);
