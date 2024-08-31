<template>
    <v-container>
        <schedule-table-widget :loading="loading" :data="classesListData" @class-selected="onClassSelected" />
    </v-container>
</template>
<script setup lang="ts">
import { ScheduleTableWidget } from "@/components/widgets/schedule";

definePageMeta({
    layout: "dashboard"
});

const loading = computed(() => status.value === "pending" || accountLoading.value);
const { account, loading: accountLoading } = await useAccount();

const { data: classesListData, status } = await useAsyncData(
    "classes-list-data",
    () => {
        if (account.value?.group_id && account.value.group_id > 0) {
            return useFetch<Shared.ListData<Classes.ReadClassDTO>>(
                `/classes?group_id=${account.value?.group_id}`,
                {},
                false
            );
        } else {
            return Promise.resolve(null);
        }
    },
    {
        getCachedData: _ => undefined,
        lazy: true,
        default: () => null,
        watch: [account]
    }
);

function onClassSelected(c: Classes.ReadClassDTO) {
    navigateTo({
        name: "dashboard-my-id-classes-classId",
        params: { id: c.lesson.subject_id, classId: c.id }
    });
}
</script>
