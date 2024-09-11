<template>
    <v-tabs v-model="tab" color="deep-purple-accent-4">
        <v-tab :value="1" prepend-icon="mdi-clock">{{ $t("components.widgets.my.class.info") }}</v-tab>
        <v-tab :value="2" prepend-icon="mdi-list-status">{{ $t("components.widgets.my.class.topics") }}</v-tab>
        <template v-if="showQuizzes">
            <v-tab :value="3" prepend-icon="mdi-help-box">{{ $t("components.widgets.my.class.quizzes") }}</v-tab>
        </template>
    </v-tabs>
    <v-tabs-window v-model="tab">
        <v-tabs-window-item :value="1">
            <v-container>
                <class-info-widget :loading="loading" :current-class="currentClass" />
            </v-container>
        </v-tabs-window-item>
        <v-tabs-window-item :value="2">
            <v-container>
                <v-row>
                    <v-col v-for="topic in currentClass?.lesson.topics" :key="topic.id" cols="12">
                        <class-topic-widget :loading="loading" :current-topic="topic" />
                    </v-col>
                </v-row>
            </v-container>
        </v-tabs-window-item>
        <v-tabs-window-item v-if="showQuizzes" :value="3">
            <v-container>
                <v-row>
                    <v-col cols="12">
                        <class-quiz-widget
                            v-for="quiz in currentClass?.lesson?.quizzes"
                            :key="quiz.id"
                            :loading="loading"
                            :quiz="quiz"
                            @question-answered="$emit('question-answered', $event)"
                        />
                    </v-col>
                </v-row>
            </v-container>
        </v-tabs-window-item>
    </v-tabs-window>
</template>
<script setup lang="ts">
import ClassQuizWidget from "./class-quiz-widget.vue";
import ClassInfoWidget from "./class-info-widget.vue";
import ClassTopicWidget from "./class-topic-widget.vue";

const props = defineProps<{
    loading: boolean;
    currentClass: Classes.ReadClassDTO | null;
}>();

defineEmits<{
    (
        e: "question-answered",
        payload: {
            answer: Classes.CreateMultipleQuestionAnswerDTO | Classes.CreateSingleQuestionAnswerDTO;
            quiz_id: number;
            question_id: number;
        }
    ): void;
}>();

const tab = ref(1);

const showQuizzes = computed(
    () => Array.isArray(props.currentClass?.lesson.quizzes) && props.currentClass?.lesson.quizzes?.length > 0
);
</script>
