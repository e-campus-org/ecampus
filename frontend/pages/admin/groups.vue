<template>
    <div>
        <v-data-table
            :headers="(headers as any[])"
            :items="groupsListData?.list || []"
            :loading="loading"
            :items-per-page="pageSize"
        >
            <template #bottom>
                <div class="text-center pt-2">
                    <v-pagination v-model="page" :length="groupsListData?.pagination.pages" />
                </div>
            </template>
        </v-data-table>
    </div>
</template>
<script setup lang="ts">
definePageMeta({
    layout: "admin"
});

const { t } = useI18n();
const dayjs = useDayjs();

const headers = computed(() => [
    {
        title: t("pages.groups.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("pages.groups.headers.title"),
        align: "start",
        sortable: false,
        key: "title"
    },
    {
        title: t("pages.groups.headers.specialityId"),
        align: "start",
        sortable: false,
        key: "speciality_id"
    },
    {
        title: t("pages.groups.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Groups.ReadGroupDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("pages.groups.headers.updatedAt"),
        align: "start",
        sortable: false,
        key: "updated_at",
        value: (item: Groups.ReadGroupDTO) => dayjs(item.updated_at).format("DD.MM.YYYY HH:mm:ss")
    }
]);

const page = ref(1);
const pageSize = ref(10);

const loading = computed(() => status.value === "pending");

const { data: groupsListData, status } = await useAsyncData(
    "client-full-info",
    () => useFetch<Shared.ListData<Groups.ReadGroupDTO>>(`/groups?page=${page.value}&page_size=${pageSize.value}`, {}),
    {
        server: false,
        watch: [page, pageSize]
    }
);
</script>
