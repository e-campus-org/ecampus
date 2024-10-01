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
                <v-btn width="10%" color="primary" class="ml-auto mt-2 mr-2" @click="onAdd">
                    {{ buttonName }}
                </v-btn>
            </template>
            <template #bottom>
                <div class="text-center pt-2">
                    <v-pagination v-model="currentPage" :length="props.data?.pagination?.pages || 0" />
                </div>
            </template>

            <template #item.actions="{ item }">
                <v-icon
                    class="me-2"
                    size="small"
                    @click="onClickEdit(item)"
                >
                    mdi-pencil
                </v-icon>
                <v-icon
                    class="me-2"
                    size="small"
                    @click="onClickDelete(item)"
                >
                    mdi-delete
                </v-icon>
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

const dialog = defineModel<boolean>('dialog')

const emit = defineEmits<{
    (e: "page-changed", page: number): void;
    (e: "delete-row" | "edit-row", item: Groups.ReadGroupDTO): void;
}>();

const { t } = useI18n();
const dayjs = useDayjs();

const buttonName = t("components.widgets.table.buttons.add")

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});

const onAdd = () => {
    dialog.value = true
}

const onClickDelete = (item: Groups.ReadGroupDTO) => {
    emit("delete-row", item);
}

const onClickEdit = (item: Groups.ReadGroupDTO) => {
    emit("edit-row", item);
}

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
        title: t("components.widgets.table.actions"),
        align: "start",
        sortable: false,
        key: "actions"
    }
]);
</script>
