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
            @questions-delete="questionsDelete"
        />
        <delete-modal v-model="isDeleteModal" :item="selectedItem" @delete="deleteItem" :name="deleteModalNames" />
    </div>
</template>

<script setup lang="ts">
import EditModal from "./edit-modal.vue";
import DeleteModal from "./delete-modul.vue";
import { ref, watch, computed } from "vue";
import { useRouter } from "vue-router"; 

const props = defineProps<{
    data: Shared.ListData<Lessons.ReadLessonDTO> | null;
    loading: boolean;
    page: number;
    pageSize: number;
}>();

const emit = defineEmits<{
    (e: "page-changed", page: number): void;
    (e: "get-item", item: Lessons.ReadLessonDTO): void;
    (e: "save-item", item: Lessons.ReadLessonDTO): void;
    (e: "add-item", item: Lessons.ReadLessonDTO): void;
    (e: "delete-item", item: Lessons.ReadLessonDTO): void;
    (e: "questions-delete", id: number): void;

}>();

const isEditModal = ref(false);
const isDeleteModal = ref(false);
const selectedItem = ref({});
const isNewItem = ref(false);
const router = useRouter();

function openEditModal(item: any) {
    isEditModal.value = false; 
    router.push(`/admin/lessons/${item.id}`); 
}
function questionsDelete(id:number){
    emit("questions-delete", id);
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
        description: "",
        questions:[]
    };
    isEditModal.value = true;
}

function addEdit(editedItem: any) {
    const trueValue = t("components.widgets.lessons.draft.trueValue");

    editedItem.is_draft = editedItem.is_draft === trueValue ? true : false;

    if (isNewItem.value) {
        emit("add-item", editedItem);
        setTimeout(()=>{        
            openEditModal(props.data?.list[props.data.list.length - 1])
        },50)
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
    title: t("components.widgets.lessons.headers.title"),
    topic: t("components.widgets.lessons.headers.topic"),
    hours_count: t("components.widgets.lessons.headers.hoursCount"),
    is_draft: t("components.widgets.lessons.headers.isDraft"),
    objectives: t("components.widgets.lessons.headers.objectives"),
    subject_id: t("components.widgets.lessons.headers.subjectId")
}));
const editModalErrors = computed(() => ({
    title: t("components.widgets.lessons.error.title"),
    topic: t("components.widgets.lessons.error.topic"),
    hours_count: t("components.widgets.lessons.error.hours_count"),
    is_draft: t("components.widgets.lessons.error.is_draft"),
    objectives: t("components.widgets.lessons.error.objectives"),
    subject_id: t("components.widgets.lessons.error.subject_id"),

    question_title: t("components.widgets.lessons.error.is_draft"),
    question_description: t("components.widgets.lessons.error.objectives"),
    question_objectives: t("components.widgets.lessons.error.subject_id")
}));
const editModalNames = computed(() => ({
    title: isNewItem.value
        ? t("components.widgets.lessons.modal.create_title")
        : t("components.widgets.lessons.modal.edit_title"),
    cancel: t("components.widgets.lessons.modal.cancel"),
    save: isNewItem.value ? t("components.widgets.lessons.action.add") : t("components.widgets.lessons.modal.save")
}));

const deleteModalNames = computed(() => ({
    title: t("components.widgets.lessons.modal.delete_title"),
    text: t("components.widgets.lessons.modal.delete_text"),
    cancel: t("components.widgets.lessons.modal.cancel"),
    delete: t("components.widgets.lessons.modal.delete")
}));

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});

const headers = computed(() => [
    {
        title: t("components.widgets.lessons.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("components.widgets.lessons.headers.title"),
        align: "start",
        sortable: false,
        key: "title"
    },
    {
        title: t("components.widgets.lessons.headers.subjectId"),
        align: "start",
        sortable: false,
        key: "subject_id"
    },
    {
        title: t("components.widgets.lessons.headers.isDraft"),
        align: "start",
        sortable: false,
        key: "is_draft"
    },
    {
        title: t("components.widgets.lessons.headers.hoursCount"),
        align: "start",
        sortable: false,
        key: "hours_count"
    },
    {
        title: t("components.widgets.lessons.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Lessons.ReadLessonDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.lessons.headers.updatedAt"),
        align: "start",
        sortable: false,
        key: "updated_at",
        value: (item: Lessons.ReadLessonDTO) => dayjs(item.updated_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.lessons.action.delete"),
        align: "center",
        sortable: false,
        key: "actions"
    }
]);

const sortedItems = computed(() => {
    if (!props.data?.list) return [];

    const trueValue = t("components.widgets.lessons.draft.trueValue");
    const falseValue = t("components.widgets.lessons.draft.falseValue");

    return [...props.data.list]
        .sort((a, b) => a.id - b.id)
        .map(item => {
            const draftMap = {
                true: trueValue,
                false: falseValue
            };

            item.is_draft = draftMap[item.is_draft.toString()] || item.is_draft;
            return item;
        });
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
