<template>
    <internal-layout>
        <template #left-menu>
            <v-list-item
                prepend-icon="mdi-certificate"
                :title="$t('layouts.admin.sideMenu.specialities')"
                :to="{ name: 'admin-specialities' }"
            >
                <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                    $t("layouts.admin.sideMenu.specialities")
                }}</v-tooltip>
            </v-list-item>
            <v-list-item
                prepend-icon="mdi-account-multiple"
                :title="$t('layouts.admin.sideMenu.groups')"
                :to="{ name: 'admin-groups' }"
            >
                <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                    $t("layouts.admin.sideMenu.groups")
                }}</v-tooltip>
            </v-list-item>
            <v-list-item
                prepend-icon="mdi-account"
                :title="$t('layouts.admin.sideMenu.accounts')"
                :to="{ name: 'admin-accounts' }"
            >
                <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                    $t("layouts.admin.sideMenu.accounts")
                }}</v-tooltip>
            </v-list-item>
            <v-list-item
                prepend-icon="mdi-cast-education"
                :title="$t('layouts.admin.sideMenu.subjects')"
                :to="{ name: 'admin-subjects' }"
            >
                <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                    $t("layouts.admin.sideMenu.subjects")
                }}</v-tooltip>
            </v-list-item>
            <v-list-item
                prepend-icon="mdi-book-open-variant"
                :title="$t('layouts.admin.sideMenu.lessons')"
                :to="{ name: 'admin-lessons' }"
            >
                <v-tooltip v-if="$vuetify.display.mdAndUp" activator="parent" location="end">{{
                    $t("layouts.admin.sideMenu.lessons")
                }}</v-tooltip>
            </v-list-item>
        </template>
    </internal-layout>
</template>
<script setup lang="ts">
import InternalLayout from "./internal.vue";
</script>
