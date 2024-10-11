<template>
    <v-container>
        <list-widget
            :data="subjectsListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
            @get-item="handleGetItem"
            @save-item="handleSaveItem"
            @add-item="handleAddItem"
            @delete-item="handleDeleteItem"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ListWidget } from "@/components/widgets/subjects";

definePageMeta({
    layout: "admin"
});
const { t } = useI18n();

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
async function handleGetItem(item) {
    const index = subjectsListData.value?.list?.findIndex(i => i.id === item.id);
    if (index !== -1) {
        try {
            const response = await useFetch(`/subjects/${item.id}`, {
                method: "GET"
            });

            if (response) {
                subjectsListData.value.list[index] = response;
                return response;
            }
        } catch (error) {
            console.error(t("components.pages.errors.getData"), error);
        }
    }
    return null;
}
async function handleSaveItem(updatedItem) {
    const index = subjectsListData.value?.list?.findIndex(i => i.id === updatedItem.id);
    if (index !== -1) {
        try {
            const payload = {
                subject: {
                    title: updatedItem.title,
                    short_title: updatedItem.shortTitle,
                    description: updatedItem.description,
                    prerequisites: updatedItem.prerequisites,
                    objectives: updatedItem.objectives,
                    required_texts: updatedItem.requiredTexts
                }
            };
            const response = await useFetch(`/subjects/${updatedItem.id}`, {
                method: "PUT",
                body: payload
            });

            if (response) {
                subjectsListData.value.list[index] = { ...updatedItem };
            }
        } catch (error) {
            useEvent("notify:error", t("components.pages.errors.saveData"));
        }
    }
}
async function handleAddItem(newItem) {
    try {
        const payload = {
            subject: {
                title: newItem.title,
                short_title: newItem.shortTitle,
                description: newItem.description,
                prerequisites: newItem.prerequisites,
                objectives: newItem.objectives,
                required_texts: newItem.requiredTexts
            }
        };

        const response = await useFetch(`/subjects`, {
            method: "POST",
            body: payload
        });

        if (response) {
            subjectsListData.value.list.push({ ...response });
        }
    } catch (error) {
        useEvent("notify:error", t("components.pages.errors.saveData"));
    }
}

async function handleDeleteItem(deleteItem) {
    try {
        await useFetch(`/subjects/${deleteItem.id}`, {
            method: "DELETE"
        });
    } catch (error) {
        useEvent("notify:error", t("components.pages.errors.deleteData"));
    }
}
</script>
