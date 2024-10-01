<template>
    <v-container>
        <list-widget
            v-model:dialog="dialogAdd"
            :data="accountsListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
            @row-delete="onClickDelete"
            @row-edit="onClickEdit"
        />

        <modal-add 
            v-model:dialog="dialogAdd"
            :group-list="groupList"
            @add-confirm="addConfirm"
        />

        <modal-delete 
            v-model:dialog="dialogDelete"
            :item="deletedAccount || {}"
            @delete-confirm="deleteConfirm"
        />

        <modal-edit 
            v-model:dialog="dialogEdit"
            :group-list="groupList"
            :item="editedItem || {}"
             @edit-confirm="editConfirm"
        />

    </v-container>
</template>
<script setup lang="ts">
    import { ListWidget, ModalAdd, ModalDelete, ModalEdit } from "@/components/widgets/accounts";

    definePageMeta({
        layout: "admin"
    });

    const page = ref(1);
    const pageSize = ref(10);
    const dialogDelete = ref(false);
    const dialogAdd = ref(false);
    const dialogEdit = ref(false);
    const deletedAccount = ref<Accounts.ReadAccountDTO>();
    const editedItem = ref<Accounts.ReadAccountDTO>();
    const groupList = computed(() => groupsListData.list);
    const groupsListData = await useFetch<Shared.ListData<Groups.ReadGroupDTO>>(
        `/groups`,
        {
            method: "GET"
        }
    );

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

    const onClickDelete = (item: Accounts.ReadAccountDTO) => {
        deletedAccount.value = item
        dialogDelete.value = true
    }

    const onClickEdit = (item: Accounts.ReadAccountDTO) => {
        editedItem.value = item
        dialogEdit.value = true
    }

    const addConfirm = async (item: Accounts.CreateAccountDTO) => {
        try {
            const data = await useFetch<Accounts.ReadAccountDTO>(
                '/accounts', {
                method: 'POST',
                body : {
                    account: item
                }
            });

            if(accountsListData.value && data) {
                accountsListData.value.list.push(data)
            }

        } catch (error) {
            console.log(error);
        }
        dialogAdd.value = false;
    }

    const deleteConfirm = async () => {
        try {
            if (accountsListData.value && deletedAccount.value) {
                await useFetch(
                    `/accounts/${deletedAccount.value.id}`, { 
                        method: 'DELETE' 
                    }
                );
                accountsListData.value.list = accountsListData.value.list.filter((item: Accounts.ReadAccountDTO) => item.id !== deletedAccount.value.id)
            }
        } catch (error) {
            console.log(error)
        }
        dialogDelete.value = false;
    }

    const editConfirm = async (item: Accounts.UpdateAccountDTO) => {
        try {
            if (accountsListData.value && editedItem.value) {
                const data = await useFetch<Accounts.ReadAccountDTO>(
                    `/accounts/${editedItem.value.id}`, {
                        method: 'PUT',
                        body: {
                            account: item
                        }
                    }
                );

                accountsListData.value.list = accountsListData.value.list.map((item: Accounts.ReadAccountDTO) => {
                    if(item.id === data.id) {
                        return data
                    }
                    return item
                })
            }
        } catch (error) {
            console.log(error)
        }
        dialogEdit.value = false
    }


</script>
