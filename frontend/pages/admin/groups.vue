<template>
    <v-container>
        <list-widget
            v-model:dialog="dialogAdd"
            :data="groupsListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
            @delete-row="onClickDelete"
            @edit-row="onClickEdit"
        />

        <modal-add 
            v-model:dialog="dialogAdd"
            :group-list="groupList"
            @add-confirm="addConfirm"
        />

        <modal-delete 
            v-model:dialog="dialogDelete"
            :item="deletedGroup || {}"
            @delete-confirm="deleteConfirm"
        />

        <modal-edit 
            v-model:dialog="dialogEdit"
            :item="editedItem || {}"
            :group-list="groupList"
            @edit-confirm="editConfirm"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ListWidget, ModalAdd, ModalDelete, ModalEdit } from "@/components/widgets/groups";

definePageMeta({
    layout: "admin"
});

const page = ref(1);
const pageSize = ref(10);
const dialogAdd = ref(false);
const dialogDelete = ref(false);
const dialogEdit = ref(false);
const deletedGroup = ref<Groups.ReadGroupDTO>();
const editedItem = ref<Groups.ReadGroupDTO>();

const loading = computed(() => status.value === "pending");
const groupList = computed(() => specialitiesListData.list)

const { data: groupsListData, status } = await useAsyncData(
    "groups-list-data",
    () => useFetch<Shared.ListData<Groups.ReadGroupDTO>>(`/groups?page=${page.value}&page_size=${pageSize.value}`, {}),
    {
        server: false,
        watch: [page, pageSize]
    }
);

const onClickDelete = (item: Groups.ReadGroupDTO) => {
    deletedGroup.value = item
    dialogDelete.value = true
}

const onClickEdit = (item: Groups.ReadGroupDTO) => {
    editedItem.value = item
    dialogEdit.value = true
}

const specialitiesListData = await useFetch<Shared.ListData<Specialities.ReadSpecialityDTO>>(
    `/specialities`,
    {
        method: "GET"
    }
);

const addConfirm = async (item: object) => {
    try {
        const body = {
            group: item
        };

        const data = await useFetch<Groups.ReadGroupDTO>('/groups', {
            method: 'POST',
            body
        });
        

        if(groupsListData.value && data) {
            groupsListData.value.list.push(data)
        }
    
    } catch (error) {
        console.log(error);
    }
    dialogAdd.value = false;
}

const deleteConfirm = async () => {
    try {
        if (groupsListData.value && deletedGroup.value) {
            await useFetch(`/groups/${deletedGroup.value.id}`, { method: 'DELETE' })
            groupsListData.value.list = groupsListData.value.list.filter((item: Groups.ReadGroupDTO) => item.id !== deletedGroup.value.id)
        }
    } catch (error) {
        console.log(error)
    }
    dialogDelete.value = false;
}

const editConfirm = async (item: object) => {
    try {
        if (groupsListData.value && editedItem.value) {
            const data = await useFetch(`/groups/${editedItem.value.id}`, {
                method: 'PUT',
                body: {
                    group: item
                }
            });

            console.log(data)
            groupsListData.value.list = groupsListData.value.list.map((item: Groups.ReadGroupDTO) => {
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
