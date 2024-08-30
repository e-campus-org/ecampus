<template>
    <v-container>
        <edit-lesson-widget :loading="loading" :lesson="currentLesson" @lesson-changed="updateLesson" />
        <topic-list-widget
            :loading="loading"
            :data="lessonTopicsListData"
            :page="page"
            :page-size="pageSize"
            @topic-selected="onTopicSelected"
        />
    </v-container>
</template>
<script setup lang="ts">
import { EditLessonWidget, TopicListWidget } from "@/components/widgets/lessons";
import { FetchError } from "ofetch";

definePageMeta({
    layout: "admin",
    validate: route => {
        return /^\d+$/.test(route.params.id as string);
    }
});

const { t } = useI18n();

const route = useRoute();
const lessonId = computed(() => Number(route.params.id));

const page = ref(1);
const pageSize = ref(10);
const localLoading = ref(false);
const loading = computed(
    () => lessonStatus.value === "pending" || lessonTopicsStatus.value === "pending" || localLoading.value
);

const { data: currentLesson, status: lessonStatus } = await useAsyncData(
    "dashboard-current-class-data",
    () => {
        if (lessonId.value && lessonId.value > 0) {
            return useFetch<Lessons.ReadLessonDTO>(`/lessons/${lessonId.value}`, {}, false);
        } else {
            return Promise.resolve(null);
        }
    },
    {
        getCachedData: _ => undefined,
        lazy: true,
        default: () => null,
        watch: [lessonId]
    }
);

const { data: lessonTopicsListData, status: lessonTopicsStatus } = await useAsyncData(
    "accounts-list-data",
    () =>
        useFetch<Shared.ListData<Lessons.ReadLessonTopicDTO>>(
            `/lesson_topics?page=${page.value}&page_size=${pageSize.value}&lesson_id=${lessonId.value}`,
            {}
        ),
    {
        server: false,
        watch: [page, pageSize, lessonId]
    }
);

async function updateLesson(lesson: Lessons.UpdateLessonDTO) {
    try {
        localLoading.value = true;
        currentLesson.value = await useFetch<Lessons.ReadLessonDTO>(
            `/lessons/${lessonId.value}`,
            {
                body: { lesson },
                method: "PUT"
            },
            false
        );
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

function onTopicSelected(topic: Lessons.ReadLessonTopicDTO) {
    console.log(topic);
}
</script>
