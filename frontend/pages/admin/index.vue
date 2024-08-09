<template>
    <nuxt-page />
</template>
<script setup lang="ts">
import { useAccountStore } from "@/store";

definePageMeta({
    // middleware: ["auth"],
    layout: "admin"
});

const accountStore = useAccountStore();
const router = useRouter();
const route = useRoute();
const isLoggedIn = computed(() => accountStore.isLoggedIn);

watchEffect(() => {
    if (isLoggedIn.value && route.name === "dashboard") {
        router.replace({ name: "dashboard" });
    }
});
</script>
