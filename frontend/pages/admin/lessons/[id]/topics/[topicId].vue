<template>
    <v-container>
        <edit-lesson-topic-widget :loading="loading" :topic="currentLessonTopic" />
    </v-container>
</template>
<script setup lang="ts">
import { EditLessonTopicWidget } from "@/components/widgets/lessons";

definePageMeta({
    layout: "admin",
    validate: route => {
        return /^\d+$/.test(route.params.id as string) && /^\d+$/.test(route.params.topicId as string);
    }
});

const route = useRoute();
const topicId = computed(() => Number(route.params.topicId));

const loading = computed(() => status.value === "pending");

const { data: currentLessonTopic, status: status } = await useAsyncData(
    "admin-current-lesson-topic-data",
    () => {
        if (topicId.value && topicId.value > 0) {
            return useFetch<Lessons.ReadLessonTopicDTO>(`/lesson_topics/${topicId.value}`, {}, false);
        } else {
            return Promise.resolve(null);
        }
    },
    {
        getCachedData: _ => undefined,
        lazy: true,
        default: () => null,
        watch: [topicId]
    }
);
</script>
