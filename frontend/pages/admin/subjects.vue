<template>
    <v-container>
        <list-widget
            :data="subjectsListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ListWidget } from "@/components/widgets/subjects";

definePageMeta({
    layout: "admin"
});

const page = ref(1);
const pageSize = ref(10);

const loading = computed(() => status.value === "pending");

const { data: subjectsListData, status } = await useAsyncData(
    "subject-list-data",
    () =>
        useFetch<Shared.ListData<Subjects.ReadSubjectDTO>>(
            `/subjects?page=${page.value}&page_size=${pageSize.value}`,
            {}
        ),
    {
        server: false,
        watch: [page, pageSize]
    }
);
</script>
