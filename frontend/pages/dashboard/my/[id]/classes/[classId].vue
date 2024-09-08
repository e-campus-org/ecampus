<template>
    <v-container>
        <class-widget :loading="loading" :current-class="currentClass" @question-answered="onQuestionAnswered" />
    </v-container>
</template>
<script setup lang="ts">
import { ClassWidget } from "@/components/widgets/my";
import { FetchError } from "ofetch";

definePageMeta({
    layout: "dashboard",
    validate: route => {
        return /^\d+$/.test(route.params.classId as string);
    }
});

const route = useRoute();
const { t } = useI18n();
const classId = computed(() => Number(route.params.classId));

const localLoading = ref(false);

const loading = computed(() => status.value === "pending" || localLoading.value);

const { data: currentClass, status } = await useAsyncData(
    "dashboard-current-class-data",
    () => {
        if (classId.value && classId.value > 0) {
            return useFetch<Classes.ReadClassDTO>(`/classes/${classId.value}`, {}, false);
        } else {
            return Promise.resolve(null);
        }
    },
    {
        getCachedData: _ => undefined,
        lazy: true,
        default: () => null,
        watch: [classId]
    }
);

async function onQuestionAnswered({
    quiz_id,
    question_id,
    answer
}: {
    answer: Classes.CreateMultipleQuestionAnswerDTO | Classes.CreateSingleQuestionAnswerDTO;
    quiz_id: number;
    question_id: number;
}) {
    try {
        localLoading.value = true;
        const result = await useFetch<Classes.ReadClassQuizQuestionDTO>(
            `/quizzes/${quiz_id}/questions/${question_id}/answer_question`,
            {
                body: {
                    answer
                },
                method: "POST"
            }
        );
        const quizToUpdate = currentClass.value?.lesson.quizzes.find(q => q.id === quiz_id);
        if (quizToUpdate) {
            quizToUpdate.questions = quizToUpdate?.questions.map(q => (q.id === result.id ? result : q));
        }
    } catch (e: unknown) {
        if (e instanceof FetchError && e.status === 401) {
            useEvent("notify:error", t("errors.unauthorized"));
        } else {
            useEvent("notify:error", t("errors.unknown"));
        }
    } finally {
        localLoading.value = false;
    }
}
</script>
