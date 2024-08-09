<template>
    <internal-layout>
        <template #left-menu>
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
        </template>
    </internal-layout>
</template>
<script setup lang="ts">
import InternalLayout from "./internal.vue";
</script>
