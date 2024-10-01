<template>
    <div class="w-100">
        <v-data-table
            :headers="(headers as any[])"
            :items="props.data?.list || []"
            :loading="loading"
            :items-per-page="props.pageSize"
            :mobile-breakpoint="0"
        >

            <template #top>
                <v-btn width="10%" color="primary" class="ml-auto mt-2 mr-2" @click="onRowAdd">
                    {{ buttonName }}
                </v-btn>
            </template>
            <template #bottom>
                <div class="text-center pt-2">
                    <v-pagination v-model="currentPage" :length="props.data?.pagination?.pages || 0" />
                </div>
            </template>

            <template #item.actions="{ item }">
                <template v-if="!item.roles.includes('admin')">
                    <v-icon
                        class="me-2"
                        size="small"
                        @click="onRowEdit(item)"
                    >
                        mdi-pencil
                    </v-icon>
                <v-icon
                    class="me-2"
                    size="small"
                    @click="onRowDelete(item)"
                >
                    mdi-delete
                </v-icon>
                </template>
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
    (e: "row-edit" | "row-delete", row: Accounts.ReadAccountDTO): void;
}>();

const dialog = defineModel<boolean>('dialog')
const { t } = useI18n();
const dayjs = useDayjs();

const buttonName = t("components.widgets.table.buttons.add")

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});

const onRowEdit = (item: Accounts.ReadAccountDTO) => {
    emit("row-edit", item);
};

const onRowDelete = (item: Accounts.ReadAccountDTO) => {
    emit("row-delete", item);
};

const onRowAdd = () => {
    dialog.value = true
}

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
    },
    {
        title: t("components.widgets.table.actions"),
        align: "start",
        sortable: false,
        key: "actions"
    }
]);
</script>
