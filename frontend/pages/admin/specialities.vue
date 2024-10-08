<template>
    <v-container>
        <list-widget
            v-model:dialog="dialogAdd"
            :data="specialitiesListData"
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
            :id="deletedId"
            v-model:dialog="dialogDelete"
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
    import { ListWidget, ModalAdd, ModalDelete, ModalEdit } from "@/components/widgets/specialities";

    definePageMeta({
        layout: "admin"
    });

    const page = ref(1);
    const pageSize = ref(10);
    const dialogAdd = ref(false);
    const dialogDelete = ref(false);
    const dialogEdit = ref(false);
    const deletedId = ref<number>();
    const editedItem = ref<Specialities.ReadSpecialityDTO>();
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

    const onClickDelete = (id: number) => {
        deletedId.value = id
        dialogDelete.value = true
    }

    const onClickEdit = (item: Specialities.ReadSpecialityDTO) => {
        editedItem.value = item
        dialogEdit.value = true
    }

    const fetchSpecialitiesList = async () => {
        specialitiesListData.value = await useFetch<Shared.ListData<Specialities.ReadSpecialityDTO>>(
            `/specialities?page=${page.value}&page_size=${pageSize.value}`,
            {}
        );
    }

    const addConfirm = async (item: Specialities.CreateSpecialityDTO) => {
        try {
            const data = await useFetch<Specialities.ReadSpecialityDTO>(
                '/specialities', {
                    method: 'POST',
                    body: {
                        speciality: item
                    }
                }
            );

            if (data) {
                fetchSpecialitiesList();
            }
        
        } catch (error) {
            useEvent("notify:error", String(error));
            console.log(error);
        }
        dialogAdd.value = false;
    }

    const deleteConfirm = async () => {
        try {
            if (deletedId.value) {
                await useFetch(
                    `/specialities/${deletedId.value}`, {
                         method: 'DELETE' 
                    }
                );

                fetchSpecialitiesList();
            }
        } catch (error) {
            useEvent("notify:error", String(error));
            console.log(error)
        }
        dialogDelete.value = false;
    }

    const editConfirm = async (item: Specialities.UpdateSpecialityDTO) => {
        try {
            if (specialitiesListData.value && editedItem.value) {
                const data = await useFetch(
                    `/specialities/${editedItem.value.id}`, {
                        method: 'PUT',
                        body: {
                            speciality: item
                        }
                    }
                );
                
                if (data) {
                    useEvent("notify:error", String(error));
                    fetchSpecialitiesList();
                }
            }
        } catch (error) {
            console.log(error)
        }
        dialogEdit.value = false
    }
</script>
