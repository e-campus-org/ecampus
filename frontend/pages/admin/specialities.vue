<template>
    <v-container>
        <list-widget
            :data="specialitiesListData"
            :loading="loading"
            :page="page"
            :page-size="pageSize"
            @page-changed="page = $event"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ListWidget } from "@/components/widgets/specialities";

definePageMeta({
    layout: "admin"
});

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
