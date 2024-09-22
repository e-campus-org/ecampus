<template>
    <v-container>
        <list-widget
            :data="accountsListData"
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
import { ListWidget } from "@/components/widgets/accounts";

definePageMeta({
    layout: "admin"
});

const page = ref(1);
const pageSize = ref(10);

const loading = computed(() => status.value === "pending");

const { data: accountsListData, status } = await useAsyncData(
    "accounts-list-data",
    () =>
        useFetch<Shared.ListData<Accounts.ReadAccountDTO>>(
            `/accounts?page=${page.value}&page_size=${pageSize.value}`,
            {}
        ),
    {
        server: false,
        watch: [page, pageSize]
    }
);

async function handleSaveItem(updatedItem) {
    const index = accountsListData.value?.list?.findIndex(i => i.id === updatedItem.id);
    if (index !== -1) {
        try {
            const payload = {
                email: updatedItem.email,
                first_name: updatedItem.firstName, // Исправил опечатки
                last_name: updatedItem.lastName, // Исправил опечатки
                group_id: updatedItem.group,
                roles: updatedItem.roles
            };
            console.log(payload);
            const response = await useFetch(`/accounts/${updatedItem.id}`, {
                method: "PUT",
                body: payload
            });

            if (response) {
                accountsListData.value.list[index] = { ...updatedItem };
            }
        } catch (error) {
            console.error("Ошибка при отправке данных на сервер:", error);
        }
    }
}
async function handleAddItem(newItem) {
    try {
        const payload = {
            account: {
                email: newItem.email,
                first_name: newItem.firstName,
                last_name: newItem.lastName,
                group_id: newItem.group,
                password: newItem.password,
                password_confirmation: newItem.passwordConfirmation,
                roles: newItem.roles
            }
        };
        console.log("Payload:", payload);

        // Отправка запроса с явной сериализацией в JSON и указанием заголовков
        const response = await useFetch(`/accounts`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json" // Важно указать, что данные в формате JSON
            },
            body: JSON.stringify(payload) // Сериализация объекта в строку JSON
        });

        console.log("Response:", response);

        // Проверка успешного ответа
        if (response.ok) {
            const responseData = await response.json(); // Преобразование ответа в JSON
            accountsListData.value.list.push({ ...responseData });
        } else {
            console.error("Ошибка: запрос завершился с кодом", response.status);
        }
    } catch (error) {
        console.error("Ошибка при отправке данных на сервер:", error);
    }
}

async function handleDeleteItem(deleteItem) {
    try {
        await useFetch(`/accounts/${deleteItem.id}`, {
            method: "DELETE"
        });
    } catch (error) {
        console.error("Ошибка при удалении элемента:", error);
    }
}
</script>
