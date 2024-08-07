<template>
    <v-layout>
        <v-navigation-drawer
            v-model="drawer"
            :rail="!$vuetify.display.xs && !$vuetify.display.sm"
            :permanent="!$vuetify.display.xs && !$vuetify.display.sm"
            :border="0"
            color="background"
        >
            <v-list density="compact" nav>
                <v-list-item
                    prepend-icon="mdi-view-dashboard"
                    :title="$t('layouts.dashboard.sideMenu.my')"
                    :to="{ name: 'dashboard-my' }"
                >
                    <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                        $t("layouts.dashboard.sideMenu.my")
                    }}</v-tooltip>
                </v-list-item>
                <v-list-item
                    prepend-icon="mdi-magnify"
                    :title="$t('layouts.dashboard.sideMenu.find')"
                    :to="{ name: 'dashboard-find' }"
                >
                    <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                        $t("layouts.dashboard.sideMenu.find")
                    }}</v-tooltip>
                </v-list-item>
            </v-list>
            <template #append>
                <v-list density="compact" nav>
                    <v-list-item
                        :prepend-icon="isDarkThemeApplied ? 'mdi-weather-night' : 'mdi-weather-sunny'"
                        :title="
                            isDarkThemeApplied
                                ? $t('layouts.dashboard.sideMenu.lightTheme')
                                : $t('layouts.dashboard.sideMenu.darkTheme')
                        "
                        @click="toggleTheme"
                    >
                        <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                            isDarkThemeApplied
                                ? $t("layouts.dashboard.sideMenu.lightTheme")
                                : $t("layouts.dashboard.sideMenu.darkTheme")
                        }}</v-tooltip>
                    </v-list-item>
                </v-list>
            </template>
        </v-navigation-drawer>

        <v-app-bar title="E | Campus" flat :order="$vuetify.display.mdAndUp ? -1 : 0" color="background">
            <template #prepend>
                <v-app-bar-nav-icon class="d-block d-md-none" @click.stop="drawer = !drawer" />
            </template>
            <template #append>
                <v-menu width="200px" rounded>
                    <template #activator="{ props }">
                        <v-btn icon v-bind="props">
                            <v-avatar>
                                <v-icon icon="mdi-account-circle" />
                            </v-avatar>
                        </v-btn>
                    </template>
                    <v-card>
                        <v-card-text>
                            <div class="mx-auto text-center">
                                <v-avatar>
                                    <v-icon icon="mdi-account-circle" />
                                </v-avatar>
                                <h3>{{ "adsa" }}</h3>
                                <p class="text-caption mt-1">
                                    {{ "asdsa@dasda.com" }}
                                </p>
                                <v-divider class="my-3" />
                                <div class="d-flex flex-column">
                                    <v-btn
                                        variant="text"
                                        rounded
                                        prepend-icon="mdi-cog"
                                        :to="{ name: 'dashboard-settings' }"
                                    >
                                        {{ t("layouts.dashboard.header.settings") }}
                                    </v-btn>
                                    <v-btn
                                        variant="text"
                                        rounded
                                        prepend-icon="mdi-account-circle"
                                        :to="{ name: 'dashboard-profile' }"
                                    >
                                        {{ t("layouts.dashboard.header.profile") }}
                                    </v-btn>
                                    <v-btn variant="text" rounded prepend-icon="mdi-logout" @click="logout">
                                        {{ t("layouts.dashboard.header.logout") }}
                                    </v-btn>
                                </div>
                            </div>
                        </v-card-text>
                    </v-card>
                </v-menu>
            </template>
        </v-app-bar>

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

const { t } = useI18n();

const drawer = ref(false);

function toggleTheme() {
    settingsStore.switchTheme();
}

function logout() {
    console.log("logout");
}
</script>
