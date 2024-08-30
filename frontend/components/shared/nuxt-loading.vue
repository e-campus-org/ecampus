<template>
    <div
        v-if="nuxtLoading"
        class="min-h-screen h-100 w-100 position-absolute d-flex justify-center align-center left-0 top-0"
        :style="{
            background: $vuetify.theme.themes[$vuetify.theme.current.dark ? 'dark' : 'light'].colors.background,
            'z-index': 1000
        }"
    >
        {{ $t("components.shared.nuxtLoading.loading") }}
    </div>
</template>
<script setup lang="ts">
const nuxtLoading = useNuxtLoading();
</script>
