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
                :items="props.data?.list || []"
                :loading="loading"
                :items-per-page="props.pageSize"
                :mobile-breakpoint="0"
                hover
                @click:row="handleRowClick"
            >
                <template #bottom>
                    <div class="text-center pt-2">
                        <v-pagination v-model="currentPage" :length="props.data?.pagination?.pages || 0" />
                    </div>
                </template>
            </v-data-table>
        </v-col>
    </v-row>
</template>
<script setup lang="ts">
const props = defineProps<{
    data: Shared.ListData<Lessons.ReadLessonTopicDTO> | null;
    loading: boolean;
    page: number;
    pageSize: number;
}>();

const emit = defineEmits<{
    (e: "page-changed", page: number): void;
    (e: "topic-selected", topic: Lessons.ReadLessonTopicDTO): void;
}>();

const { t } = useI18n();
const dayjs = useDayjs();

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});

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
        title: t("components.widgets.lessons.topics.headers.lessonId"),
        align: "start",
        sortable: false,
        key: "lesson_id"
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
    }
]);

function handleRowClick(_: PointerEvent, { item }: { item: Lessons.ReadLessonTopicDTO }) {
    emit("topic-selected", item);
}
</script>
