<template>
    <div
        v-if="nuxtLoading"
        class="h-screen w-100 z-9999 position-absolute d-flex justify-center align-center left-0 top-0"
        :style="{
            background: $vuetify.theme.themes[$vuetify.theme.current.dark ? 'dark' : 'light'].colors.background
        }"
    >
        {{ $t("components.shared.nuxtLoading.loading") }}
    </div>
</template>
<script setup lang="ts">
const nuxtLoading = useNuxtLoading();
</script>
