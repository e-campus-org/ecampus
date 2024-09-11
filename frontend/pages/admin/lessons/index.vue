<template>
    <v-container>
        <list-widget
            :data="lessonsListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
            @lesson-selected="onLessonSelected"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ListWidget } from "@/components/widgets/lessons";

definePageMeta({
    layout: "admin"
});

const page = ref(1);
const pageSize = ref(10);

const loading = computed(() => status.value === "pending");

const { data: lessonsListData, status } = await useAsyncData(
    "lesson-list-data",
    () =>
        useFetch<Shared.ListData<Lessons.ReadLessonDTO>>(`/lessons?page=${page.value}&page_size=${pageSize.value}`, {}),
    {
        server: false,
        watch: [page, pageSize]
    }
);

function onLessonSelected(lesson: Lessons.ReadLessonDTO) {
    navigateTo({
        name: "admin-lessons-id",
        params: { id: lesson.id }
    });
}
</script>
