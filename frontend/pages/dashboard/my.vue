<template>
    <v-container>
        <subject-list-widget :loading="loading" :subjects="mySubjects" />
    </v-container>
</template>

<script setup lang="ts">
import { SubjectListWidget } from "@/components/widgets/my";

definePageMeta({
    layout: "dashboard"
});

const loading = computed(() => status.value === "pending" || accountLoading.value);
const { account, loading: accountLoading } = await useAccount();

const { data: mySubjects, status } = await useAsyncData(
    "subjects-list-data",
    () => {
        if (account.value?.group_id && account.value.group_id > 0) {
            return useFetch<Subjects.ReadSubjectDTO[]>(`/groups/${account.value?.group_id}/subjects`, {}, false);
        } else {
            return Promise.resolve([]);
        }
    },
    {
        getCachedData: _ => undefined,
        lazy: true,
        default: () => [],
        watch: [account]
    }
);
</script>
