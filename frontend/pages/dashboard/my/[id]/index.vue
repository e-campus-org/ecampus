<template>
    <v-container>
        <class-list-widget
            :loading="loading"
            :classes-data="classesData"
            @page-changed="page = $event"
            @class-selected="onClassSelected"
        />
    </v-container>
</template>
<script setup lang="ts">
import { ClassListWidget } from "@/components/widgets/my";

definePageMeta({
    layout: "dashboard",
    validate: route => {
        return /^\d+$/.test(route.params.id as string);
    }
});

const route = useRoute();
const subjectId = computed(() => Number(route.params.id));

const { account, loading: accountLoading } = await useAccount();

const loading = computed(() => status.value === "pending" || accountLoading.value);

const page = useState("dashboard-classes-page", () => 1);
const pageSize = useState("dashboard-classes-page-size", () => 10);

const { data: classesData, status } = await useAsyncData(
    "dashboard-classes-list-data",
    () => {
        if (subjectId.value && subjectId.value > 0) {
            return useFetch<Shared.ListData<Classes.ReadClassDTO>>(
                `/classes?subject_id=${subjectId.value}&group_id=${account.value?.group_id}&page=${page.value}&page_size=${pageSize.value}`,
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
        watch: [subjectId, page, pageSize, account]
    }
);

function onClassSelected(classId: number) {
    navigateTo({
        name: "dashboard-my-id-classes-classId",
        params: { id: subjectId.value, classId }
    });
}
</script>
