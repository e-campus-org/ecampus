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
import { ref, watch, computed, onMounted } from "vue";

const props = defineProps<{
    data: Shared.ListData<Subjects.ReadSubjectDTO> | null;
    loading: boolean;
    page: number;
    pageSize: number;
}>();

const emit = defineEmits<{
    (e: "page-changed", page: number): void;
    (e: "get-item", item: Subjects.ReadSubjectDTO): Promise<Subjects.ReadSubjectDTO | null>;
    (e: "save-item", item: Subjects.ReadSubjectDTO): void;
    (e: "add-item", item: Subjects.ReadSubjectDTO): void;
    (e: "delete-item", item: Subjects.ReadSubjectDTO): void;
}>();

const isEditModal = ref(false);
const isDeleteModal = ref(false);
const selectedItem = ref<Subjects.ReadSubjectDTO | null>(null);
const isNewItem = ref(false);

function openEditModal(item: any) {
    emit("get-item", item);
    setTimeout(() => {
        const data = props.data?.list.find(el => el.id === item.id);
        if (data) {
            selectedItem.value = data;
            isEditModal.value = true;
        }
    }, 400);
}
function openDeleteModal(item: any) {
    isNewItem.value = false;
    selectedItem.value = { ...item };
    isDeleteModal.value = true;
}

function openAddModal() {
    isNewItem.value = true;
    selectedItem.value = {};
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
    title: t("components.widgets.subjects.headers.title"),
    shortTitle: t("components.widgets.subjects.headers.shortTitle"),
    description: t("components.widgets.subjects.headers.description"),
    prerequisites: t("components.widgets.subjects.headers.prerequisites"),
    objectives: t("components.widgets.subjects.headers.objectives"),
    requiredTexts: t("components.widgets.subjects.headers.requiredTexts")
}));
const editModalErrors = computed(() => ({
    title: t("components.widgets.subjects.error.title"),
    shortTitle: t("components.widgets.subjects.error.shortTitle"),
    description: t("components.widgets.subjects.error.description"),
    prerequisites: t("components.widgets.subjects.error.prerequisites"),
    objectives: t("components.widgets.subjects.error.objectives"),
    requiredTexts: t("components.widgets.subjects.error.requiredTexts")
}));
const editModalNames = computed(() => ({
    title: isNewItem.value
        ? t("components.widgets.subjects.modal.create_title")
        : t("components.widgets.subjects.modal.edit_title"),
    cancel: t("components.widgets.subjects.modal.cancel"),
    save: isNewItem.value ? t("components.widgets.subjects.action.add") : t("components.widgets.subjects.modal.save")
}));

const deleteModalNames = computed(() => ({
    title: t("components.widgets.subjects.modal.delete_title"),
    text: t("components.widgets.subjects.modal.delete_text"),
    cancel: t("components.widgets.subjects.modal.cancel"),
    delete: t("components.widgets.subjects.modal.delete")
}));

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});

const headers = computed(() => [
    {
        title: t("components.widgets.subjects.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("components.widgets.subjects.headers.title"),
        align: "start",
        sortable: false,
        key: "title"
    },
    {
        title: t("components.widgets.subjects.headers.shortTitle"),
        align: "start",
        sortable: false,
        key: "short_title"
    },
    {
        title: t("components.widgets.subjects.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Subjects.ReadSubjectDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.specialities.action.delete"),
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
