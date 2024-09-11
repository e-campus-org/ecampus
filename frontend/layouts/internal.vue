<template>
    <v-layout>
        <client-only>
            <v-navigation-drawer
                v-model="drawer"
                :rail="isDesktop"
                :permanent="isDesktop"
                :border="0"
                color="background"
            >
                <v-list density="compact" nav>
                    <slot name="left-menu" />
                    <template v-if="accountInfo?.roles?.includes('admin')">
                        <v-list-item
                            v-if="$route.name?.toString?.().startsWith('dashboard')"
                            prepend-icon="mdi-database-cog"
                            :title="$t('layouts.internal.sideMenu.admin')"
                            :to="{ name: 'admin' }"
                        >
                            <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                                $t("layouts.internal.sideMenu.admin")
                            }}</v-tooltip>
                        </v-list-item>
                        <v-list-item
                            v-else-if="$route.name?.toString?.().startsWith('admin')"
                            prepend-icon="mdi-view-dashboard"
                            :title="$t('layouts.dashboard.sideMenu.my')"
                            :to="{ name: 'dashboard-my' }"
                        >
                            <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                                $t("layouts.dashboard.sideMenu.my")
                            }}</v-tooltip>
                        </v-list-item>
                    </template>
                </v-list>
                <template #append>
                    <v-list density="compact" nav>
                        <v-menu width="200px" rounded>
                            <template #activator="{ props }">
                                <v-list-item
                                    v-bind="props"
                                    prepend-icon="mdi-translate"
                                    :title="$t('layouts.internal.sideMenu.changeLocale')"
                                >
                                    <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">
                                        {{ $t("layouts.internal.sideMenu.changeLocale") }}
                                    </v-tooltip>
                                </v-list-item>
                            </template>
                            <v-card>
                                <v-list density="compact">
                                    <v-list-item
                                        :title="$t('layouts.internal.sideMenu.locales.english')"
                                        @click="toggleLocale('en')"
                                    />
                                    <v-list-item
                                        :title="$t('layouts.internal.sideMenu.locales.russian')"
                                        @click="toggleLocale('ru')"
                                    />
                                </v-list>
                            </v-card>
                        </v-menu>

                        <v-list-item
                            :prepend-icon="isDarkThemeApplied ? 'mdi-weather-night' : 'mdi-weather-sunny'"
                            :title="
                                isDarkThemeApplied
                                    ? $t('layouts.internal.sideMenu.lightTheme')
                                    : $t('layouts.internal.sideMenu.darkTheme')
                            "
                            @click="toggleTheme"
                        >
                            <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                                isDarkThemeApplied
                                    ? $t("layouts.internal.sideMenu.lightTheme")
                                    : $t("layouts.internal.sideMenu.darkTheme")
                            }}</v-tooltip>
                        </v-list-item>
                    </v-list>
                </template>
            </v-navigation-drawer>
        </client-only>

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
                                <p>{{ accountInfo?.email }}</p>
                                <p class="text-caption mt-1">
                                    {{ accountInfo?.roles?.join(", ") }}
                                </p>
                                <v-divider class="my-3" />
                                <div class="d-flex flex-column">
                                    <v-btn
                                        variant="text"
                                        rounded
                                        prepend-icon="mdi-cog"
                                        :to="{ name: 'dashboard-settings' }"
                                    >
                                        {{ $t("layouts.internal.header.settings") }}
                                    </v-btn>
                                    <v-btn
                                        variant="text"
                                        rounded
                                        prepend-icon="mdi-account-circle"
                                        :to="{ name: 'dashboard-profile' }"
                                    >
                                        {{ $t("layouts.internal.header.profile") }}
                                    </v-btn>
                                    <v-btn variant="text" rounded prepend-icon="mdi-logout" @click="logout">
                                        {{ $t("layouts.internal.header.logout") }}
                                    </v-btn>
                                </div>
                            </div>
                        </v-card-text>
                    </v-card>
                </v-menu>
            </template>
        </v-app-bar>

        <v-main class="d-flex align-center justify-center position-relative" style="min-height: 300px">
            <nuxt-loading />
            <nuxt-page />
        </v-main>
    </v-layout>
</template>
<script setup lang="ts">
import { useI18n } from "vue-i18n";
import { useSettingsStore } from "@/store";
import { NuxtLoading } from "@/components/shared";

const settingsStore = useSettingsStore();

const isDarkThemeApplied = computed(() => settingsStore.isDarkThemeApplied);

const vuetify = useVuetify();

const isDesktop = computed(() => (vuetify.display.mdAndUp as unknown as globalThis.ComputedRef<boolean>).value);

const i18n = useI18n();

// should use isDesktop value because if initial is false,
// then in desktop mode drawer will hide after moving to another layout
// (e.g from dashboard to admin and vice versa). And if it true, drawer in desktop
// mode will work correctly, but on mobile it always open on start.
const drawer = ref(isDesktop.value);

const logout = useLogout();

// useLoadingIndicator doesn't works correctly

const { accountInfo } = useJwt();
function toggleTheme() {
    settingsStore.switchTheme();
}

function toggleLocale(locale: "en" | "ru") {
    i18n.locale.value = locale;
}
</script>
