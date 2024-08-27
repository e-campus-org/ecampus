<template>
    <v-container>
        <lesson-list-widget :loading="loading" :lessons-data="lessonsData" @page-changed="page = $event" />
    </v-container>
</template>
<script setup lang="ts">
import { LessonListWidget } from "@/components/widgets/my";

definePageMeta({
    layout: "dashboard",
    validate: route => {
        return /^\d+$/.test(route.params.id as string);
    }
});

const route = useRoute();
const subjectId = computed(() => Number(route.params.id));

const loading = computed(() => status.value === "pending");

const page = useState("dashboard-lessons-page", () => 1);
const pageSize = useState("dashboard-lessons-page-size", () => 10);

const { data: lessonsData, status } = await useAsyncData(
    "subject-lessons-list-data",
    () => {
        if (subjectId.value && subjectId.value > 0) {
            return useFetch<Shared.ListData<Lessons.ReadLessonDTO>>(
                `/lessons?subject_id=${subjectId.value}&page=${page.value}&page_size=${pageSize.value}`,
                {},
                false
            );
        } else {
            return Promise.resolve(null);
        }
    },
    {
        getCachedData: _ => undefined,
        lazy: true,
        default: () => null,
        watch: [subjectId, page, pageSize]
    }
);
</script>
