<template>
    <v-card :title="$t('components.widgets.my.class.quiz')">
        <template v-if="!started && totalQuestions > 0">
            <v-card-item :title="quiz.title" :subtitle="quiz.description" />
            <v-card-actions>
                <v-btn variant="text" @click="startQuiz">{{ $t("components.widgets.my.class.startQuiz") }}</v-btn>
            </v-card-actions>
        </template>

        <template v-if="currentQuestion">
            <v-card-item>
                <p>{{ currentQuestion.title }}</p>
                <small>{{ currentQuestion.subtitle }}</small>
            </v-card-item>
            <v-card-text>
                <template v-if="currentQuestion.type === 'single' && currentQuestion.answers?.length > 0">
                    <v-radio-group v-model="radioModel">
                        <v-radio v-for="answer in currentQuestion.answers" :key="answer.id" :value="answer.id">
                            <template #label>
                                <div>
                                    <div>{{ answer.title }}</div>
                                    <small>{{ answer.subtitle }}</small>
                                </div>
                            </template>
                        </v-radio>
                    </v-radio-group>
                </template>
                <template v-else-if="currentQuestion.type === 'multiple' && answers?.length > 0">
                    <v-checkbox v-for="answer in answers" :key="answer.id">
                        <template #label>
                            <div>
                                <div>{{ answer.title }}</div>
                                <small>{{ answer.subtitle }}</small>
                            </div>
                        </template></v-checkbox
                    >
                </template>
            </v-card-text>
            <v-card-actions>
                <v-btn v-if="currentQuestionIndex > 0" variant="text" @click="currentQuestionIndex--">{{
                    $t("components.widgets.my.class.previousQuestion")
                }}</v-btn>
                <v-btn v-if="canGoNext" variant="text" @click="currentQuestionIndex++">{{
                    $t("components.widgets.my.class.nextQuestion")
                }}</v-btn>
                <v-btn v-if="canAnswerQuestion" variant="text" @click="answerQuestion">{{
                    $t("components.widgets.my.class.submitQuestion")
                }}</v-btn>
            </v-card-actions>
        </template>
    </v-card>
</template>
<script setup lang="ts">
const props = defineProps<{
    loading: boolean;
    quiz: Classes.ReadClassQuizDTO;
}>();

const emit = defineEmits<{
    (
        e: "question-answered",
        payload: {
            answer: Classes.CreateMultipleQuestionAnswerDTO | Classes.CreateSingleQuestionAnswerDTO;
            quiz_id: number;
            question_id: number;
        }
    ): void;
}>();

const started = ref(false);
const radioModel = ref<number>(0);
const checkboxModel = ref<number[]>([]);

const currentQuestionIndex = ref(-1);
const currentQuestion = computed(() => props.quiz?.questions?.[currentQuestionIndex.value] || null);
const totalQuestions = computed(() => props.quiz?.questions?.length || 0);

const answers = computed(() => currentQuestion.value?.answers || []);

const canGoNext = computed(
    () => currentQuestionIndex.value < totalQuestions.value - 1 && currentQuestion.value?.your_answer?.length > 0
);

const canAnswerQuestion = computed(() => currentQuestion.value?.your_answer?.length === 0);

function startQuiz() {
    started.value = true;
    currentQuestionIndex.value = 0;
}

function answerQuestion() {
    if (currentQuestion.value?.type === "single") {
        emit("question-answered", {
            answer: {
                answer_id: radioModel.value
            },
            quiz_id: props.quiz.id,
            question_id: currentQuestion.value.id
        });
    } else if (currentQuestion.value?.type === "multiple") {
        emit("question-answered", {
            answer: {
                answer_ids: checkboxModel.value
            },
            quiz_id: props.quiz.id,
            question_id: currentQuestion.value.id
        });
    }
}

watch(
    currentQuestion,
    newVal => {
        if (newVal?.your_answer?.length > 0) {
            if (newVal.type === "single") {
                radioModel.value = newVal.your_answer[0].answer?.answer_id;
            } else if (newVal.type === "multiple") {
                checkboxModel.value = newVal.your_answer[0].answer?.answer_ids;
            }
        } else {
            radioModel.value = 0;
            checkboxModel.value = [];
        }
    },
    {
        immediate: true
    }
);
</script>
