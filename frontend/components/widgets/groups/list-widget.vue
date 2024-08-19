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
    data: Shared.ListData<Groups.ReadGroupDTO> | null;
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
    }
]);
</script>
