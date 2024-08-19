<template>
    <v-container>
        <schedule-table-widget :loading="loading" :data="classesListData" />
    </v-container>
</template>
<script setup lang="ts">
import { ScheduleTableWidget } from "@/components/widgets/schedule";

definePageMeta({
    layout: "dashboard"
});

const loading = computed(() => status.value === "pending" || accountLoading.value);
const { account, loading: accountLoading } = useAccount();

const { data: classesListData, status } = await useAsyncData(
    "classes-list-data",
    () => {
        if (account.value?.group_id && account.value.group_id > 0) {
            return useFetch<Shared.ListData<Classes.ReadClassDTO>>(`/classes?=${account.value?.group_id}`, {}, false);
        } else {
            return Promise.resolve(null);
        }
    },
    {
        server: false,
        watch: [account]
    }
);
</script>
