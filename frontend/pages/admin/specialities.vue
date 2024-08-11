<template>
    <div>
        <v-data-table
            :headers="(headers as any[])"
            :items="specialitiesListData?.list || []"
            :loading="loading"
            :items-per-page="pageSize"
        >
            <template #bottom>
                <div class="text-center pt-2">
                    <v-pagination v-model="page" :length="specialitiesListData?.pagination.pages" />
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
        title: t("pages.specialities.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("pages.specialities.headers.title"),
        align: "start",
        sortable: false,
        key: "title"
    },
    {
        title: t("pages.specialities.headers.code"),
        align: "start",
        sortable: false,
        key: "code"
    },
    {
        title: t("pages.specialities.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Specialities.ReadSpecialityDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("pages.specialities.headers.updatedAt"),
        align: "start",
        sortable: false,
        key: "updated_at",
        value: (item: Specialities.ReadSpecialityDTO) => dayjs(item.updated_at).format("DD.MM.YYYY HH:mm:ss")
    }
]);

const page = ref(1);
const pageSize = ref(10);

const loading = computed(() => status.value === "pending");

const { data: specialitiesListData, status } = await useAsyncData(
    "client-full-info",
    () =>
        useFetch<Shared.ListData<Specialities.ReadSpecialityDTO>>(
            `/specialities?page=${page.value}&page_size=${pageSize.value}`,
            {}
        ),
    {
        server: false,
        watch: [page, pageSize]
    }
);
</script>
