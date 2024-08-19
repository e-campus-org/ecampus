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
    data: Shared.ListData<Accounts.ReadAccountDTO> | null;
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
        title: t("components.widgets.accounts.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("components.widgets.accounts.headers.email"),
        align: "start",
        sortable: false,
        key: "email"
    },
    {
        title: t("components.widgets.accounts.headers.firstName"),
        align: "start",
        sortable: false,
        key: "first_name"
    },
    {
        title: t("components.widgets.accounts.headers.lastName"),
        align: "start",
        sortable: false,
        key: "last_name"
    },
    {
        title: t("components.widgets.accounts.headers.group"),
        align: "start",
        sortable: false,
        key: "group_id"
    },
    {
        title: t("components.widgets.accounts.headers.roles"),
        align: "start",
        sortable: false,
        key: "roles",
        value: (item: Accounts.ReadAccountDTO) => item.roles?.join(", ")
    },
    {
        title: t("components.widgets.accounts.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Accounts.ReadAccountDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.accounts.headers.updatedAt"),
        align: "start",
        sortable: false,
        key: "updated_at",
        value: (item: Accounts.ReadAccountDTO) => dayjs(item.updated_at).format("DD.MM.YYYY HH:mm:ss")
    }
]);
</script>
