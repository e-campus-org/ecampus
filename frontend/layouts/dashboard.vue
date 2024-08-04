<template>
    <v-layout>
        <v-app-bar title="E | Campus" flat order="-1" color="transparent">
            <template #append>
                <v-btn icon="mdi-dots-vertical" />
            </template>
        </v-app-bar>
        <v-navigation-drawer rail permanent :border="0" color="transparent">
            <v-list density="compact" nav>
                <v-list-item
                    v-tooltip:end="$t('layouts.dashboard.sideMenu.my')"
                    prepend-icon="mdi-view-dashboard"
                    to="my"
                />
                <v-list-item
                    v-tooltip:end="$t('layouts.dashboard.sideMenu.find')"
                    prepend-icon="mdi-magnify"
                    to="find"
                />
            </v-list>
            <template #append>
                <v-list density="compact" nav>
                    <v-list-item
                        v-tooltip:end="
                            isDarkThemeApplied
                                ? $t('layouts.dashboard.sideMenu.lightTheme')
                                : $t('layouts.dashboard.sideMenu.darkTheme')
                        "
                        :prepend-icon="isDarkThemeApplied ? 'mdi-weather-night' : 'mdi-weather-sunny'"
                        @click="toggleTheme"
                    />
                </v-list>
            </template>
        </v-navigation-drawer>

        <v-main class="d-flex align-center justify-center" style="min-height: 300px">
            <nuxt-page />
        </v-main>
    </v-layout>
</template>
<script setup lang="ts">
import { useI18n } from "vue-i18n";
import { useSettingsStore } from "@/store";

const settingsStore = useSettingsStore();

const isDarkThemeApplied = computed(() => settingsStore.isDarkThemeApplied);

const router = useRouter();

const { t } = useI18n();

const items = ref([
    [
        {
            label: "unknown",
            slot: "account",
            disabled: true
        }
    ],
    [
        {
            label: t("layouts.dashboard.header.settings"),
            icon: "i-heroicons-cog-8-tooth-20-solid",
            click: () => router.push({ name: "settings" })
        },
        {
            label: t("layouts.dashboard.header.profile"),
            icon: "i-heroicons-user-20-solid",
            click: () => router.push({ name: "profile" })
        }
    ],
    [
        {
            label: t("layouts.dashboard.header.logout"),
            icon: "i-heroicons-arrow-right-on-rectangle-20-solid"
        }
    ]
]);

function toggleTheme() {
    settingsStore.switchTheme();
}
</script>
