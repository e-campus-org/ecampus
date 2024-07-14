<template>
    <div class="flex flex-col justify-start min-h-screen min-w-screen">
        <div class="w-full h-12 flex flex-row justify-between">
            <div class="flex flex-row gap-2 items-center">
                <div class="w-12 flex flex-row justify-center items-center">
                    <u-avatar alt="E" />
                </div>
                E | Campus
            </div>
            <div class="flex flex-row justify-end items-center">
                <u-tooltip
                    class="block sm:hidden"
                    :text="t('layouts.dashboard.sideMenu.showContents')"
                    :popper="{ placement: 'right' }"
                >
                    <u-button
                        icon="i-heroicons-bars-3-20-solid"
                        color="primary"
                        variant="link"
                        @click="toggleSideBar"
                    />
                </u-tooltip>
                <div class="w-12 flex flex-row justify-center items-center">
                    <u-dropdown :items="items">
                        <u-avatar :alt="'AD'" />
                    </u-dropdown>
                </div>
            </div>
        </div>
        <div class="flex-1 flex flex-row">
            <div class="w-12 hidden sm:flex flex-col justify-between items-center">
                <div class="flex flex-col justify-start gap-2">
                    <nuxt-link :to="{ name: 'find' }">
                        <u-tooltip :text="t('layouts.dashboard.sideMenu.find')" :popper="{ placement: 'right' }">
                            <u-button icon="i-heroicons-magnifying-glass" color="primary" variant="link" />
                        </u-tooltip>
                    </nuxt-link>
                    <nuxt-link :to="{ name: 'my' }">
                        <u-tooltip :text="t('layouts.dashboard.sideMenu.my')" :popper="{ placement: 'right' }">
                            <u-button icon="i-heroicons-squares-2x2-solid" color="primary" variant="link" />
                        </u-tooltip>
                    </nuxt-link>
                </div>
                <div class="flex flex-col justify-end gap-2">
                    <u-tooltip
                        :text="
                            isDarkThemeApplied
                                ? t('layouts.dashboard.sideMenu.lightTheme')
                                : t('layouts.dashboard.sideMenu.darkTheme')
                        "
                        :popper="{ placement: 'right' }"
                    >
                        <u-button
                            :icon="isDarkThemeApplied ? 'i-heroicons-moon-20-solid' : 'i-heroicons-sun-20-solid'"
                            color="primary"
                            variant="link"
                            @click="toggleTheme"
                        />
                    </u-tooltip>
                </div>
            </div>
            <div id="dashboard-container" class="flex-1 max-h-[calc(100vh-3rem)] overflow-scroll">
                <div class="container h-full px-2 mx-auto">
                    <nuxt-page />
                </div>
            </div>
        </div>
        <u-slideover v-model="sideBar" side="left">
            <u-card
                class="flex flex-col flex-1"
                :ui="{
                    body: { base: 'flex-1 overflow-scroll' },
                    ring: '',
                    divide: 'divide-y divide-gray-100 dark:divide-gray-800'
                }"
            >
                <template #header>
                    <div class="flex items-center justify-between">
                        <h3 class="text-base font-semibold leading-6 text-gray-900 dark:text-white">
                            {{ $t("layouts.dashboard.sideMenu.header") }}
                        </h3>
                        <u-button variant="ghost" icon="i-heroicons-x-mark-20-solid" @click="sideBar = false" />
                    </div>
                </template>
                <u-vertical-navigation v-if="menuMobileMode" :links="mobileMenuTop" />
                <template v-if="menuMobileMode" #footer>
                    <u-vertical-navigation :links="mobileMenuBottom" />
                </template>
            </u-card>
        </u-slideover>
    </div>
</template>
<script setup lang="ts">
import { useI18n } from "vue-i18n";
import { useSettingsStore } from "@/store";

const settingsStore = useSettingsStore();

const viewport = useViewport();
const menuMobileMode = ref(false);

const isDarkThemeApplied = computed(() => settingsStore.isDarkThemeApplied);

const router = useRouter();

const { t } = useI18n();

const sideBar = ref(false);

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

const mobileMenuTop = computed(() => {
    const menu = [
        {
            label: t("layouts.dashboard.sideMenu.my"),
            icon: "i-heroicons-squares-2x2-solid",
            to: { name: "my" },
            click: toggleSideBar
        }
    ];

    return menu;
});

const mobileMenuBottom = ref([
    {
        label: isDarkThemeApplied.value
            ? t("layouts.dashboard.sideMenu.lightTheme")
            : t("layouts.dashboard.sideMenu.darkTheme"),
        icon: isDarkThemeApplied.value ? "i-heroicons-moon-20-solid" : "i-heroicons-sun-20-solid",
        click: toggleTheme
    }
]);

function toggleTheme() {
    settingsStore.switchTheme();
}

function toggleSideBar() {
    sideBar.value = !sideBar.value;
}

watch(
    viewport.breakpoint,
    newBreakpoint => {
        menuMobileMode.value = newBreakpoint === "xs";
    },
    { immediate: true }
);
</script>
<style>
.main-content {
    height: calc(100vh - 4rem);
    max-height: calc(100vh - 4rem);
    overflow: hidden;
}

.page-wrapper {
    overflow-y: scroll;
    -ms-overflow-style: none;
    scrollbar-width: none;
    padding-bottom: 20px;
}
.page-wrapper::-webkit-scrollbar {
    display: none;
}

.p-sidebar .p-sidebar-content {
    padding: 0;
}
.p-menu {
    border: none;
    background: unset;
}
</style>
