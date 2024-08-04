import { defineStore } from "pinia";
import { ref } from "vue";
import { useI18n } from "vue-i18n";

export const useSettingsStore = defineStore("e-campus-settings", () => {
    const i18n = useI18n();
    const locale = ref<Locale>("en");
    const selectedTheme = useCookie<"dark" | "light">("selected-theme", { default: () => "dark" });

    const theme = useTheme();

    const isDarkThemeApplied = computed(() => theme.global.name.value === "dark");

    function setLocale(value: Locale) {
        locale.value = value;
    }

    function switchTheme() {
        if (isDarkThemeApplied.value) {
            selectedTheme.value = "light";
        } else {
            selectedTheme.value = "dark";
        }
    }

    watch(locale, newValue => (i18n.locale.value = newValue as Locale));
    watch(selectedTheme, newValue => (theme.global.name.value = newValue), { immediate: true });

    return {
        setLocale,
        locale,
        selectedTheme,
        switchTheme,
        isDarkThemeApplied
    };
});
