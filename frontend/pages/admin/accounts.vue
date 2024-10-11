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
const { t } = useI18n();

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
                first_name: updatedItem.firstName,
                last_name: updatedItem.lastName,
                group_id: updatedItem.group,
                roles: updatedItem.roles
            };
            const response = await useFetch(`/accounts/${updatedItem.id}`, {
                method: "PUT",
                body: payload
            });

            if (response) {
                accountsListData.value.list[index] = { ...updatedItem };
            }
        } catch (error) {
            useEvent("notify:error", t("components.pages.errors.saveData"));
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

        const response = await useFetch(`/accounts`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload)
        });

        if (response) {
            accountsListData.value.list.push({ ...response });
        }
    } catch (error) {
        useEvent("notify:error", t("components.pages.errors.saveData"));
    }
}

async function handleDeleteItem(deleteItem) {
    try {
        await useFetch(`/accounts/${deleteItem.id}`, {
            method: "DELETE"
        });
    } catch (error) {
        useEvent("notify:error", t("components.pages.errors.deleteData"));
    }
}
</script>
