<template>
    <div class="w-100">
        <v-data-table
            :headers="(headers as any[])"
            :items="props.data?.list || []"
            :loading="loading"
            :items-per-page="props.pageSize"
            :mobile-breakpoint="0"
        >
            <template #bottom>
                <div class="text-center pt-2">
                    <v-pagination v-model="currentPage" :length="props.data?.pagination?.pages || 0" />
                </div>
            </template>
        </v-data-table>
    </div>
</template>
<script setup lang="ts">
const props = defineProps<{
    data: Shared.ListData<Lessons.ReadLessonDTO> | null;
    loading: boolean;
    page: number;
    pageSize: number;
}>();

const emit = defineEmits<{
    (e: "page-changed", page: number): void;
}>();

const { t } = useI18n();
const dayjs = useDayjs();

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
    }
]);
</script>
