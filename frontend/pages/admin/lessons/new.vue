<template>
    <v-container>
        <div v-for="(topic, i) in topics" :key="i" class="mb-2">
            <tiptap-editor />
        </div>
        <v-fab icon="mdi-plus" location="top end" absolute @click="addNewTopic()" />
    </v-container>
</template>
<script setup lang="ts">
import { TiptapEditor } from "@/components/shared";

definePageMeta({
    layout: "admin"
});

const topics = ref<Lessons.CreateLessonTopicDTO[]>([]);

function addNewTopic() {
    topics.value.push({
        title: "",
        description: "",
        objectives: "",
        content: "",
        lesson_id: 1
    });
}
</script>
