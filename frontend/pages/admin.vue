<template>
    <nuxt-page />
</template>
<script setup lang="ts">
const { isFresh } = useJwt();

watch(
    isFresh,
    newValue => {
        if (!newValue) {
            navigateTo({ name: "auth" });
        }
    },
    { immediate: true }
);
</script>
