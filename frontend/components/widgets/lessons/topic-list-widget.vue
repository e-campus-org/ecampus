<template>
    <v-row>
        <v-col cols="12">
            <h3 class="text-h3 text-center mt-5">
                {{ $t("components.widgets.lessons.edit.topicsTitle") }}
            </h3>
        </v-col>
        <v-col cols="12">
            <v-data-table
                :headers="(headers as any[])"
                :items="sortedItems"
                :loading="loading"
                :items-per-page="props.pageSize"
                :mobile-breakpoint="0"
                hover
                @click:row="handleRowClick"
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
            <create-topic-modal
                v-model="isEditModal"
                :loading="loading"
                @addTopic="addTopic"
            />
            <delete-modal v-model="isDeleteModal" :item="selectedItem" @delete="deleteItem" :name="deleteModalNames" />
        </v-col>
    </v-row>
</template>
<script setup lang="ts">
import CreateTopicModal from "./create-topic-modal.vue";
import DeleteModal from "./delete-modul.vue";

const props = defineProps<{
    data: Shared.ListData<Lessons.ReadLessonTopicDTO> | null;
    loading: boolean;
    page: number;
    pageSize: number;
}>();

const emit = defineEmits<{
    (e: "page-changed", page: number): void;
    (e: "topic-selected", topic: Lessons.ReadLessonTopicDTO): void;
    (e: "lesson-topic-add", lesson: any): void;
    (e: "lesson-topic-delete", lesson: any): void;
    
}>();

import { ref, computed } from "vue";

const { t } = useI18n();
const dayjs = useDayjs();

const isEditModal = ref(false);
const isDeleteModal = ref(false);
const selectedItem = ref({});

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});
function openAddModal() {
    isEditModal.value = true;
}
function addTopic(values:any){
    emit("lesson-topic-add", {
        title: values.title,
        content: values.content
    });
}
function openDeleteModal(item: any) {
    selectedItem.value = { ...item };
    isDeleteModal.value = true;
}
function deleteItem(item: any) {
    const index = props.data?.list?.findIndex(i => i.id === item.id);
    if (index !== -1) {
        props.data!.list!.splice(index, 1);
    }
    emit("lesson-topic-delete", item);
}

const deleteModalNames = computed(() => ({
    title: t("components.widgets.lessons.modal.delete_topic_title"),
    text: t("components.widgets.lessons.modal.delete_topic_text"),
    cancel: t("components.widgets.lessons.modal.cancel"),
    delete: t("components.widgets.lessons.modal.delete")
}));
const headers = computed(() => [
    {
        title: t("components.widgets.lessons.topics.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("components.widgets.lessons.topics.headers.title"),
        align: "start",
        sortable: false,
        key: "title"
    },
    {
        title: t("components.widgets.lessons.topics.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Lessons.ReadLessonDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.lessons.topics.headers.updatedAt"),
        align: "start",
        sortable: false,
        key: "updated_at",
        value: (item: Lessons.ReadLessonDTO) => dayjs(item.updated_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.lessons.modal.delete"),
        align: "center",
        sortable: false,
        key: "actions"
    }
]);

function handleRowClick(_: PointerEvent, { item }: { item: Lessons.ReadLessonTopicDTO }) {
    emit("topic-selected", item);
}
const sortedItems = computed(() => {
    if (!props.data?.list) return [];

    return [...props.data.list]
        .sort((a, b) => a.id - b.id)
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