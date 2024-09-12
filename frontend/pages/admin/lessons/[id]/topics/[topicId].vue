<template>
    <v-container>
        <edit-lesson-topic-widget
            :loading="loading"
            :topic="currentLessonTopic"
            @lesson-topic-changed="updateLessonTopic"
        />
    </v-container>
</template>
<script setup lang="ts">
import { EditLessonTopicWidget } from "@/components/widgets/lessons";
import { FetchError } from "ofetch";

definePageMeta({
    layout: "admin",
    validate: route => {
        return /^\d+$/.test(route.params.id as string) && /^\d+$/.test(route.params.topicId as string);
    }
});

const { t } = useI18n();
const route = useRoute();
const lessonId = computed(() => Number(route.params.id));
const topicId = computed(() => Number(route.params.topicId));
const localLoading = ref(false);
const loading = computed(() => status.value === "pending" || localLoading.value);

const { data: currentLessonTopic, status: status } = await useAsyncData(
    "admin-current-lesson-topic-data",
    () => {
        if (topicId.value && topicId.value > 0) {
            return useFetch<Lessons.ReadLessonTopicDTO>(`/lesson_topics/${topicId.value}`, {});
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

async function updateLessonTopic(dto: Lessons.UpdateLessonTopicDTO) {
    try {
        localLoading.value = true;
        currentLessonTopic.value = await useFetch<Lessons.ReadLessonTopicDTO>(`/lesson_topics/${topicId.value}`, {
            body: { lesson_topic: { ...dto, lesson_id: lessonId.value } },
            method: "PUT"
        });
    } catch (e: unknown) {
        if (e instanceof FetchError && e.status === 401) {
            useEvent("notify:error", t("errors.unauthorized"));
        } else {
            useEvent("notify:error", t("errors.unknown"));
        }
    } finally {
        localLoading.value = false;
    }
}
</script>
