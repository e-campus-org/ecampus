<template>
    <v-container>
        <list-widget
            :data="lessonsListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
            @lesson-selected="onLessonSelected"
            @get-item="handleGetItem"
            @save-item="handleSaveItem"
            @add-item="handleAddItem"
            @delete-item="handleDeleteItem"
            @questions-delete="handleDeleteQuestions"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ListWidget } from "@/components/widgets/lessons";
const { t } = useI18n();

definePageMeta({
    layout: "admin"
});

const page = ref(1);
const pageSize = ref(10);

const loading = computed(() => status.value === "pending");

const { data: lessonsListData, status } = await useAsyncData(
    "lesson-list-data",
    () =>
        useFetch<Shared.ListData<Lessons.ReadLessonDTO>>(
            `/lessons?page=${page.value}&page_size=${pageSize.value}`, 
            {}
        ),
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
async function handleGetItem(item) {
    const index = lessonsListData.value?.list?.findIndex(i => i.id === item.id);
    if (index !== -1) {
        try {
            const lessons = await useFetch(`/lessons/${item.id}`, {
                method: "GET"
            });
            const lessonTopics = await useFetch(`/lesson_topics`, {
                method: "GET"
            });
            const lessonTopicsFilter = lessonTopics?.list?.filter(lessonTopic => lessonTopic.lesson_id === item.id);

            if (lessons && lessonTopics && lessonTopicsFilter) {
                lessonsListData.value.list[index] = {...lessons, questions: lessonTopicsFilter};

                return lessons;
            }
        } catch (error) {
            useEvent("notify:error", t("components.pages.errors.getData"));
        }
    }
    return null;
}
async function handleSaveItem(updatedItem) {
    const index = lessonsListData.value?.list?.findIndex(i => i.id === updatedItem.id);
    if (index !== -1) {
        try {
            const payloadLessons = {
                lesson: {
                    title: updatedItem.title,
                    is_draft:updatedItem.is_draft,
                    topic:updatedItem.topic,
                    subject_id:updatedItem.subject_id
                }
            };
            
            const response = await useFetch(`/lessons/${updatedItem.id}`, {
                method: "PUT",
                body: payloadLessons
            });

            for (const item of updatedItem.questions) {
                const payloadLessonsTopics = {
                    lesson_topic: {
                        title: item.title,
                        description:item.description,
                        objectives:item.objectives
                    }
                };

                await useFetch(`/lesson_topics/${item.id}`, {
                    method: "PUT",
                    body: payloadLessonsTopics
                });
            }

            if (response) {
                lessonsListData.value.list[index] = { ...updatedItem };
            }
        } catch (error) {
            useEvent("notify:error", t("components.pages.errors.saveData"));
        }
    }
}

async function handleAddItem(newItem) {
    try {
        const payload = {
            lesson: {
                title: newItem.title,
                topic: newItem.topic,
                hours_count: newItem.hours_count,
                is_draft: newItem.is_draft,
                subject_id: newItem.subject_id
            }
        };

        const response = await useFetch(`/lessons`, {
            method: "POST",
            body: payload
        });

        if (response && response.id) {
            for (const item of newItem.questions) {
                const payloadLessonsTopics = {
                    lesson_topic: {
                        title: item.title,
                        description: item.description,
                        objectives: item.objectives,
                        content: {},
                        lesson_id: response.id 
                    }
                };

                await useFetch(`/lesson_topics`, {
                    method: "POST",
                    body: payloadLessonsTopics
                });
            }

            lessonsListData.value.list.push({ ...response });
        } 
    } catch (error) {
        useEvent("notify:error", t("components.pages.errors.saveData"));
    }
}


async function handleDeleteItem(deleteItem) {
    try {
        await useFetch(`/lessons/${deleteItem.id}`, {
            method: "DELETE"
        });
    } catch (error) {
        useEvent("notify:error", t("components.pages.errors.deleteData"));
    }
}
async function handleDeleteQuestions(deleteId:number) {
    try {
        console.log(deleteId)
        await useFetch(`/lesson_topics/${deleteId}`, {
            method: "DELETE"
        });
    } catch (error) {
        useEvent("notify:error", t("components.pages.errors.deleteData"));
    }
}
</script>
