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
async function handleGetItem(item) {
    const index = lessonsListData.value?.list?.findIndex(i => i.id === item.id);
    if (index !== -1) {
        try {
            const response = await useFetch(`/lessons/${item.id}`, {
                method: "GET"
            });

            if (response) {
                lessonsListData.value.list[index] = response;
                return response;
            }
        } catch (error) {
            console.error("Ошибка при получении данных:", error);
        }
    }
    return null;
}
async function handleSaveItem(updatedItem) {
    const index = lessonsListData.value?.list?.findIndex(i => i.id === updatedItem.id);
    if (index !== -1) {
        try {
            const payload = {
                lesson: {
                    title: updatedItem.title,
                    topic: updatedItem.topic,
                    hours_count: updatedItem.hours_count,
                    is_draft: updatedItem.is_draft,
                    objectives: updatedItem.objectives,
                    subject_id: updatedItem.subject_id
                }
            };
            const response = await useFetch(`/lessons/${updatedItem.id}`, {
                method: "PUT",
                body: payload
            });

            if (response) {
                lessonsListData.value.list[index] = { ...updatedItem };
            }
        } catch (error) {
            console.error("Ошибка при отправке данных на сервер:", error);
        }
    }
}
async function handleAddItem(newItem) {
    try {
        console.log(newItem);
        const payload = {
            lesson: {
                title: newItem.title,
                topic: newItem.topic,
                hours_count: newItem.hours_count,
                is_draft: newItem.is_draft,
                objectives: newItem.objectives,
                subject_id: newItem.subject_id
            }
        };

        const response = await useFetch(`/lessons`, {
            method: "POST",
            body: payload
        });

        if (response) {
            lessonsListData.value.list.push({ ...response });
        }
    } catch (error) {
        console.error("Ошибка при отправке данных на сервер:", error);
    }
}

async function handleDeleteItem(deleteItem) {
    try {
        await useFetch(`/lessons/${deleteItem.id}`, {
            method: "DELETE"
        });
    } catch (error) {
        console.error("Ошибка при удалении элемента:", error);
    }
}
</script>
