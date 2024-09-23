<template>
    <div>
        <v-data-table
            :headers="(headers as any[])"
            :items="props.data?.list || []"
            :loading="loading"
            :items-per-page="props.pageSize"
            :mobile-breakpoint="0"
        >
            <template #top>
                <v-btn width="10%" color="primary" class="ml-auto mt-2 mr-2" @click="onAdd">
                    Добавить
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
                    @click="onClickDelete(item.id)"
                >
                    mdi-delete
                </v-icon>
            </template>
        </v-data-table>
    </div>
</template>
<script setup lang="ts">
const dialog = defineModel<boolean>('dialog')

const props = defineProps<{
    data: Shared.ListData<Specialities.ReadSpecialityDTO> | null;
    loading: boolean;
    page: number;
    pageSize: number;
}>();

const emit = defineEmits<{
    (e: "page-changed" | "delete-row", page: number): void;
    (e: "edit-row", item: Specialities.ReadSpecialityDTO): void;
}>();

const { t } = useI18n();
const dayjs = useDayjs();

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});

const onAdd = () => {
    dialog.value = true
}

const onClickDelete = (id: number) => {
    emit("delete-row", id);
}

const onClickEdit = (item: Specialities.ReadSpecialityDTO) => {
    emit("edit-row", item);
}

const headers = computed(() => [
    {
        title: t("components.widgets.specialities.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("components.widgets.specialities.headers.title"),
        align: "start",
        sortable: false,
        key: "title"
    },
    {
        title: t("components.widgets.specialities.headers.code"),
        align: "start",
        sortable: false,
        key: "code"
    },
    {
        title: t("components.widgets.specialities.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Specialities.ReadSpecialityDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.specialities.headers.updatedAt"),
        align: "start",
        sortable: false,
        key: "updated_at",
        value: (item: Specialities.ReadSpecialityDTO) => dayjs(item.updated_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: "Действия",
        align: "start",
        sortable: false,
        key: "actions"
    }
]);
</script>
