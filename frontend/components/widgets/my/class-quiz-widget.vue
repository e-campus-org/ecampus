<template>
    <v-card>
        <template #title>
            <div class="d-flex flex-row justify-space-between align-center w-100">
                <div>{{ $t("components.widgets.my.class.quiz") }}</div>
                <div>
                    <span>{{ totalAnsweredQuestion }} / {{ totalQuestions }}</span>
                    <span v-if="totalGrade" class="ml-2">{{ $t("components.widgets.my.class.mark", { totalGrade }) }}</span>
                </div>
            </div>
        </template>
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
                    <v-radio-group v-model="radioModel" :disabled="disableAnswer">
                        <v-radio v-for="answer in currentQuestion.answers" :key="answer.id" :value="answer.id">
                            <template #label>
                                <div>
                                    <div>
                                        {{ answer.title }}
                                    </div>
                                    <template v-if="answer.subtitle">
                                        <small
                                            :class="{
                                                'text-red': answer.id !== currentQuestion.your_answer?.[0].correct,
                                                'text-green': answer.id === currentQuestion.your_answer?.[0].correct
                                            }"
                                        >
                                            {{ answer.subtitle }}
                                        </small>
                                    </template>
                                </div>
                            </template>
                        </v-radio>
                    </v-radio-group>
                </template>
                <template v-else-if="currentQuestion.type === 'multiple' && answers?.length > 0">
                    <v-checkbox
                        v-for="answer in answers"
                        :key="answer.id"
                        :disabled="disableAnswer"
                        :model-value="checkboxModel.includes(answer.id)"
                        @update:model-value="updateCheckbox(answer.id, $event as boolean)"
                    >
                        <template #label>
                            <div>
                                <div>{{ answer.title }}</div>
                                <template v-if="answer.subtitle">
                                    <small
                                        :class="{
                                            'text-red': !(currentQuestion.your_answer?.[0].correct as number[])?.includes?.(answer.id),
                                            'text-green': (currentQuestion.your_answer?.[0].correct as number[])?.includes?.(answer.id)
                                        }"
                                    >
                                        {{ answer.subtitle }}
                                    </small>
                                </template>
                            </div>
                        </template>
                    </v-checkbox>
                </template>
            </v-card-text>
            <v-card-actions>
                <v-btn v-if="currentQuestionIndex > 0" variant="text" @click="currentQuestionIndex--">{{
                    $t("components.widgets.my.class.previousQuestion")
                }}</v-btn>
                <v-btn v-if="canGoNext" variant="text" @click="currentQuestionIndex++">{{
                    $t("components.widgets.my.class.nextQuestion")
                }}</v-btn>
                <v-btn v-if="showAnswerButton" :disabled="!canAnswer" variant="text" @click="answerQuestion">{{
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

const questions = computed(() => {
    if (Array.isArray(props.quiz.questions)) {
        const questions = [...props.quiz.questions];
        return questions.sort((a, b) => a.order - b.order);
    } else {
        return [];
    }
});

const currentQuestionIndex = ref(-1);
const currentQuestion = computed(() => questions.value?.[currentQuestionIndex.value] || null);
const totalQuestions = computed(() => props.quiz?.questions?.length || 0);
const totalAnsweredQuestion = computed(
    () => props.quiz?.questions?.filter(q => q.your_answer?.length > 0)?.length || 0
);
const totalGrade = computed(() => props.quiz?.questions?.reduce((acc, curr) => acc + curr.your_answer[0].grade, 0));

const answers = computed(() => currentQuestion.value?.answers || []);

const canGoNext = computed(() => currentQuestionIndex.value < totalQuestions.value - 1 && disableAnswer.value);

const disableAnswer = computed(() => currentQuestion.value?.your_answer?.length > 0);

const canAnswer = computed(() => {
    if (currentQuestion.value?.type === "single") {
        return radioModel.value > 0;
    } else if (currentQuestion.value?.type === "multiple") {
        return checkboxModel.value?.length > 0;
    } else {
        return false;
    }
});

const showAnswerButton = computed(() => currentQuestion.value?.your_answer?.length === 0);

function startQuiz() {
    started.value = true;
    currentQuestionIndex.value = 0;
}

function updateCheckbox(id: number, value: boolean) {
    if (value) {
        checkboxModel.value = [...checkboxModel.value, id];
    } else {
        checkboxModel.value = checkboxModel.value.filter(val => val !== id);
    }
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
                radioModel.value = newVal.your_answer[0]?.answer_id || 0;
            } else if (newVal.type === "multiple") {
                checkboxModel.value = newVal.your_answer[0]?.answer_ids || [];
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

watch(
    () => props.quiz,
    newVal => {
        if (newVal && newVal.questions?.find(q => q.your_answer?.length > 0)) {
            startQuiz();
        }
    },
    {
        immediate: true
    }
);
</script>
