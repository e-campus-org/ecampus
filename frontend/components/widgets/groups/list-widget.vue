<template>
    <div class="table-wrapper">
        <v-data-table
            :headers="headers"
            :items="sortedItems"
            :loading="loading"
            :items-per-page="props.pageSize"
            :mobile-breakpoint="0"
            @click:row="(event, item) => openEditModal(item.item)"
        >
            <template #item.actions="{ item }">
                <v-btn @click.stop="openDeleteModal(item)" icon elevation="0">
                    <v-icon>mdi-delete</v-icon>
                </v-btn>
            </template>

            <template #bottom>
                <div class="pagination-wrapper">
                    <v-pagination
                        v-model="currentPage"
                        :length="props.data?.pagination?.pages || 0"
                        class="pagination"
                    />
                    <v-btn icon large @click="openAddModal" class="add-button">
                        <v-icon large>mdi-plus</v-icon>
                    </v-btn>
                </div>
            </template>
        </v-data-table>

        <edit-modal
            :headers="editModalHeaders"
            :name="editModalNames"
            :err="editModalErrors"
            v-model="isEditModal"
            :item="selectedItem"
            @save="addEdit"
        />
        <delete-modal v-model="isDeleteModal" :item="selectedItem" @delete="deleteItem" :name="deleteModalNames" />
    </div>
</template>

<script setup lang="ts">
import EditModal from "./edit-modal.vue";
import DeleteModal from "./delete-modul.vue";
import { ref, watch, computed } from "vue";

const props = defineProps<{
    data: Shared.ListData<Groups.ReadSpecialityDTO> | null;
    loading: boolean;
    page: number;
    pageSize: number;
}>();

const emit = defineEmits<{
    (e: "page-changed", page: number): void;
    (e: "save-item", item: Groups.ReadSpecialityDTO): void;
    (e: "add-item", item: Groups.ReadSpecialityDTO): void;
    (e: "delete-item", item: Groups.ReadSpecialityDTO): void;
}>();

const isEditModal = ref(false);
const isDeleteModal = ref(false);
const selectedItem = ref({});
const isNewItem = ref(false);

function openEditModal(item: any) {
    isNewItem.value = false;
    selectedItem.value = { ...item };
    isEditModal.value = true;
}

function openDeleteModal(item: any) {
    isNewItem.value = false;
    selectedItem.value = { ...item };
    isDeleteModal.value = true;
}

function openAddModal() {
    isNewItem.value = true;
    selectedItem.value = {
        id: null,
        title: "",
        code: "",
        description: ""
    };
    isEditModal.value = true;
}

function addEdit(editedItem: any) {
    if (isNewItem.value) {
        emit("add-item", editedItem);
    } else {
        emit("save-item", editedItem);
    }
    closeModal();
    isNewItem.value = false;
}

function deleteItem(editedItem: any) {
    const index = props.data?.list?.findIndex(i => i.id === editedItem.id);
    if (index !== -1) {
        props.data!.list!.splice(index, 1);
    }
    emit("delete-item", editedItem);
}

function closeModal() {
    isEditModal.value = false;
    isDeleteModal.value = false;
    selectedItem.value = {};
}

watch(isEditModal, newVal => {
    if (!newVal) {
        closeModal();
    }
});
watch(isDeleteModal, newVal => {
    if (!newVal) {
        closeModal();
    }
});

const { t } = useI18n();
const dayjs = useDayjs();

const editModalHeaders = computed(() => ({
    title: t("components.widgets.groups.headers.title"),
    specialityId: t("components.widgets.groups.headers.specialityId"),
    description: t("components.widgets.groups.headers.description")
}));
const editModalErrors = computed(() => ({
    title: t("components.widgets.groups.error.title"),
    specialityId: t("components.widgets.groups.error.specialityId"),
    description: t("components.widgets.groups.error.description")
}));
const editModalNames = computed(() => ({
    title: isNewItem.value
        ? t("components.widgets.groups.modal.create_title")
        : t("components.widgets.groups.modal.edit_title"),
    cancel: t("components.widgets.groups.modal.cancel"),
    save: isNewItem.value ? t("components.widgets.groups.action.add") : t("components.widgets.groups.modal.save")
}));

const deleteModalNames = computed(() => ({
    title: t("components.widgets.groups.modal.delete_title"),
    text: t("components.widgets.groups.modal.delete_text"),
    cancel: t("components.widgets.groups.modal.cancel"),
    delete: t("components.widgets.groups.modal.delete")
}));

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});

const headers = computed(() => [
    {
        title: t("components.widgets.groups.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("components.widgets.groups.headers.title"),
        align: "start",
        sortable: false,
        key: "title"
    },
    {
        title: t("components.widgets.groups.headers.specialityId"),
        align: "start",
        sortable: false,
        key: "speciality_id"
    },
    {
        title: t("components.widgets.groups.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Groups.ReadGroupDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.groups.headers.updatedAt"),
        align: "start",
        sortable: false,
        key: "updated_at",
        value: (item: Groups.ReadGroupDTO) => dayjs(item.updated_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.groups.action.delete"),
        align: "center",
        sortable: false,
        key: "actions"
    }
]);

const sortedItems = computed(() => {
    return props.data?.list ? [...props.data.list].sort((a, b) => a.id - b.id) : [];
});
</script>

<style scoped>
.table-wrapper {
    display: flex;
    flex-direction: column;
    height: 100%;
}

.pagination-wrapper {
    display: grid;
    grid-template-columns: 1fr auto;
    align-items: center;
    padding: 16px;
}

.pagination {
    min-width: 240px;
    justify-self: center;
}

.add-button {
    margin-left: 16px;
}
</style>
