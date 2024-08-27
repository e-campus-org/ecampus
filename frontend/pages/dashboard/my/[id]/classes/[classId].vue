<template>
    <div>{{ classId }}</div>
</template>
<script setup lang="ts">
definePageMeta({
    layout: "dashboard",
    validate: route => {
        return /^\d+$/.test(route.params.classId as string);
    }
});

const route = useRoute();
const classId = computed(() => Number(route.params.classId));

const loading = computed(() => status.value === "pending");

const { data: currentClass, status } = await useAsyncData(
    "dashboard-current-class-data",
    () => {
        if (classId.value && classId.value > 0) {
            return useFetch<Classes.ReadClassDTO>(`/classes/${classId.value}`, {}, false);
        } else {
            return Promise.resolve(null);
        }
    },
    {
        getCachedData: _ => undefined,
        lazy: true,
        default: () => null,
        watch: [classId]
    }
);
</script>
