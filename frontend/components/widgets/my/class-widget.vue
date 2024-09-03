<template>
    <v-tabs v-model="tab" color="deep-purple-accent-4">
        <v-tab :value="1" prepend-icon="mdi-clock">{{ $t("components.widgets.my.class.info") }}</v-tab>
        <v-tab :value="2" prepend-icon="mdi-list-status">{{ $t("components.widgets.my.class.topics") }}</v-tab>
        <v-tab :value="3" prepend-icon="mdi-help-box">{{ $t("components.widgets.my.class.quizzes") }}</v-tab>
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
        <v-tabs-window-item :value="3">
            <v-container>
                <v-row>
                    <v-col
                        v-if="currentClass?.lesson?.quizzes?.length && currentClass?.lesson?.quizzes?.length > 0"
                        cols="12"
                    >
                        <class-quiz-widget
                            v-for="quiz in currentClass?.lesson?.quizzes"
                            :key="quiz.id"
                            :loading="loading"
                            :quiz="quiz"
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

defineProps<{
    loading: boolean;
    currentClass: Classes.ReadClassDTO | null;
}>();

const tab = ref(1);
</script>
