<template>
    <v-container>
        <list-widget
            :data="specialitiesListData"
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
import { ListWidget } from "@/components/widgets/specialities";
import { ref } from "vue";

definePageMeta({
    layout: "admin"
});

const page = ref(1);
const pageSize = ref(10);

const loading = computed(() => status.value === "pending");

const { data: specialitiesListData, status } = await useAsyncData(
    "specialities-list-data",
    () =>
        useFetch<Shared.ListData<Specialities.ReadSpecialityDTO>>(
            `/specialities?page=${page.value}&page_size=${pageSize.value}`,
            {}
        ),
    {
        server: false,
        watch: [page, pageSize]
    }
);

async function handleSaveItem(updatedItem) {
    const index = specialitiesListData.value?.list?.findIndex(i => i.id === updatedItem.id);
    if (index !== -1) {
        try {
            const payload = {
                speciality: {
                    title: updatedItem.title,
                    code: updatedItem.code,
                    description: updatedItem.description
                }
            };

            const response = await useFetch(`/specialities/${updatedItem.id}`, {
                method: "PUT",
                body: payload
            });

            if (response) {
                specialitiesListData.value.list[index] = { ...updatedItem };
            }
        } catch (error) {
            console.error("Ошибка при отправке данных на сервер:", error);
        }
    }
}
async function handleAddItem(newItem) {
    try {
        const payload = {
            speciality: {
                title: newItem.title,
                code: newItem.code,
                description: newItem.description
            }
        };

        const response = await useFetch(`/specialities`, {
            method: "POST",
            body: payload
        });

        if (response) {
            specialitiesListData.value.list.push({ ...response });
        }
    } catch (error) {
        console.error("Ошибка при отправке данных на сервер:", error);
    }
}

async function handleDeleteItem(deleteItem) {
    try {
        await useFetch(`/specialities/${deleteItem.id}`, {
            method: "DELETE"
        });
    } catch (error) {
        console.error("Ошибка при удалении элемента:", error);
    }
}
</script>
