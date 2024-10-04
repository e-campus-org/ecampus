<template>
    <v-container>
        <list-widget
            v-model:dialog="dialogAdd"
            :data="subjectsListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
            @delete-row="onClickDelete"
            @edit-row="onClickEdit"
        />

        <modal-add 
            v-model:dialog="dialogAdd"
            @add-confirm="addConfirm"
        />

        <modal-delete 
            v-model:dialog="dialogDelete"
            :item="deletedItem || {}"
            @delete-confirm="deleteConfirm"
        />

        <modal-edit 
            v-model:dialog="dialogEdit"
            :item="editedItem || {}"
            @edit-confirm="editConfirm"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ListWidget, ModalAdd, ModalDelete, ModalEdit } from "@/components/widgets/subjects";

definePageMeta({
    layout: "admin"
});

const page = ref(1);
const pageSize = ref(10);
const dialogAdd = ref(false);
const dialogDelete = ref(false);
const dialogEdit = ref(false);
const deletedItem = ref<Subjects.ReadSubjectDTO>();
const editedItem = ref<Subjects.ReadSubjectDTO>();
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

const onClickDelete = (item: Subjects.ReadSubjectDTO) => {
    deletedItem.value = item
    dialogDelete.value = true
}

const onClickEdit = (item: Subjects.ReadSubjectDTO) => {
    editedItem.value = item
    dialogEdit.value = true
}

const fetchSubjectsList = async () => {
    subjectsListData.value = await useFetch<Shared.ListData<Subjects.ReadSubjectDTO>>(
        `/subjects?page=${page.value}&page_size=${pageSize.value}`,
        {}
    );
}

const addConfirm = async (item: Subjects.CreateSubjectDTO) => {
    try {
        const data = await useFetch<Subjects.ReadSubjectDTO>(
            '/subjects', {
                method: 'POST',
                body: {
                    subject: item
                } 
            }
        );

        if (data) {
            fetchSubjectsList();
        }
    
    } catch (error) {
        useEvent("notify:error", String(error));
        console.log(error);
    }
    dialogAdd.value = false;
}

const deleteConfirm = async () => {
    try {
        if (deletedItem.value) {
            await useFetch(
                `/subjects/${deletedItem.value.id}`, {
                     method: 'DELETE' 
                }
            );

            fetchSubjectsList();
        }
    } catch (error) {
        useEvent("notify:error", String(error));
        console.log(error)
    }
    dialogDelete.value = false;
}

const editConfirm = async (item: Subjects.UpdateSubjectDTO) => {
    try {
        if (subjectsListData.value && editedItem.value) {
            const data = await useFetch(
                `/subjects/${editedItem.value.id}`, {
                    method: 'PUT',
                    body: {
                        subject: item
                    }
                }
            );

            if (data) {
                useEvent("notify:error", String(error));
                fetchSubjectsList();
            }
        }
    } catch (error) {
        console.log(error)
    }
    dialogEdit.value = false
}
</script>
