<template>
    <v-container>
        <edit-lesson-widget :loading="loading" :lesson="currentLesson" :subjects=subjectsListData @lesson-changed="updateLesson" />
        <topic-list-widget
            :loading="loading"
            :data="lessonTopicsListData"
            :page="page"
            :page-size="pageSize"
            @topic-selected="onTopicSelected"
            @lesson-topic-add="onTopicAdd"
            @lesson-topic-delete="onTopicDelete"
        />
    </v-container>
</template>
<script setup lang="ts">
import { FetchError } from "ofetch";
import EditLessonWidget from "@/components/widgets/lessons/edit-lesson-widget.vue";  
import TopicListWidget from "@/components/widgets/lessons/topic-list-widget.vue";  

definePageMeta({
    layout: "admin",
    validate: route => {
        return /^\d+$/.test(route.params.id as string);
    },
});

const { t } = useI18n();

const route = useRoute();
const lessonId = computed(() => Number(route.params.id));

const page = ref(1);
const pageSize = ref(10);
const localLoading = ref(false);
const loading = computed(
    () => lessonStatus.value === "pending" || lessonTopicsStatus.value === "pending" || localLoading.value || subjectsStatus.value === "pending"
);

const { data: currentLesson, status: lessonStatus } = await useAsyncData(
    "admin-current-lesson-data",
    () => {
        if (lessonId.value && lessonId.value > 0) {
            return useFetch<Lessons.ReadLessonDTO>(`/lessons/${lessonId.value}`, {});
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
const { data: subjectsListData, status: subjectsStatus } = await useAsyncData(
    "subjects-list-data",
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
async function updateLesson(lesson: Lessons.UpdateLessonDTO) {
    try {
        localLoading.value = true;
        currentLesson.value = await useFetch<Lessons.ReadLessonDTO>(`/lessons/${lessonId.value}`, {
            body: { lesson },
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

function onTopicSelected(topic: Lessons.ReadLessonTopicDTO) {
    navigateTo({
        name: "admin-lessons-id-topics-topicId",
        params: { id: lessonId.value, topicId: topic.id }
    });
}

async function onTopicAdd(topic: any) {
    try {
        localLoading.value = true;

        const payloadLessonsTopics = {
            lesson_topic: {
                title: topic?.title,
                lesson_id: currentLesson.value?.id 
            }
        };

        const response = await useFetch(`/lesson_topics`, {
            method: "POST",
            body: payloadLessonsTopics
        });
        lessonTopicsListData.value.list.push({ ...response });
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

async function onTopicDelete(deleteId) {
    try {
        await useFetch(`/lesson_topics/${deleteId.id}`, {
            method: "DELETE"
        });
    } catch (error) {
        useEvent("notify:error", t("components.pages.errors.deleteData"));
    }
}
</script>
