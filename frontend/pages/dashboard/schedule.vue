<template>
    <v-container>
        <schedule-table-widget :loading="loading" :data="classesListData" />
    </v-container>
</template>
<script setup lang="ts">
import { ScheduleTableWidget } from "@/components/widgets/schedule";

definePageMeta({
    layout: "dashboard"
});

const loading = computed(() => status.value === "pending");

const { data: classesListData, status } = await useAsyncData(
    "classes-list-data",
    () => useFetch<Shared.ListData<Classes.ReadClassDTO>>(`/classes`, {}, false),
    {
        server: false
        // watch: [page, pageSize]
    }
);
</script>
