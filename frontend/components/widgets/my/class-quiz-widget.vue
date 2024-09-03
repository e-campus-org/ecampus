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
                    <v-radio-group>
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
            </v-card-text>
            <v-card-actions>
                <v-btn v-if="currentQuestionIndex > 0" variant="text" @click="currentQuestionIndex--">{{
                    $t("components.widgets.my.class.previousQuestion")
                }}</v-btn>
                <v-btn
                    v-if="currentQuestionIndex < totalQuestions - 1"
                    variant="text"
                    @click="currentQuestionIndex++"
                    >{{ $t("components.widgets.my.class.nextQuestion") }}</v-btn
                >
                <v-btn v-if="currentQuestionIndex === totalQuestions - 1" variant="text">{{
                    $t("components.widgets.my.class.finishQuiz")
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

const started = ref(false);
const currentQuestionIndex = ref(-1);
const currentQuestion = computed(() => props.quiz.questions[currentQuestionIndex.value]);
const totalQuestions = computed(() => props.quiz.questions.length || 0);

function startQuiz() {
    started.value = true;
    currentQuestionIndex.value = 0;
}
</script>
