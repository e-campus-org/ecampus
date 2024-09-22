<template>
    <v-container>
        <list-widget
            :data="groupsListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
            @save-item="handleSaveItem"
            @add-item="handleAddItem"
            @delete-item="handleDeleteItem"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ListWidget } from "@/components/widgets/groups";

definePageMeta({
    layout: "admin"
});

const page = ref(1);
const pageSize = ref(10);

const loading = computed(() => status.value === "pending");

const { data: groupsListData, status } = await useAsyncData(
    "groups-list-data",
    () => useFetch<Shared.ListData<Groups.ReadGroupDTO>>(`/groups?page=${page.value}&page_size=${pageSize.value}`, {}),
    {
        server: false,
        watch: [page, pageSize]
    }
);
async function handleSaveItem(updatedItem) {
    const index = groupsListData.value?.list?.findIndex(i => i.id === updatedItem.id);
    if (index !== -1) {
        try {
            const payload = {
                group: {
                    title: updatedItem.title,
                    code: updatedItem.code,
                    description: updatedItem.description
                }
            };
            console.log(updatedItem);
            const response = await useFetch(`/groups/${updatedItem.id}`, {
                method: "PUT",
                body: payload
            });

            if (response) {
                groupsListData.value.list[index] = { ...updatedItem };
            }
        } catch (error) {
            console.error("Ошибка при отправке данных на сервер:", error);
        }
    }
}
async function handleAddItem(newItem) {
    try {
        const payload = {
            group: {
                title: newItem.title,
                code: newItem.code,
                description: newItem.description
            }
        };

        const response = await useFetch(`/groups`, {
            method: "POST",
            body: payload
        });

        if (response) {
            groupsListData.value.list.push({ ...response });
        }
    } catch (error) {
        console.error("Ошибка при отправке данных на сервер:", error);
    }
}

async function handleDeleteItem(deleteItem) {
    try {
        await useFetch(`/groups/${deleteItem.id}`, {
            method: "DELETE"
        });
    } catch (error) {
        console.error("Ошибка при удалении элемента:", error);
    }
}
</script>
