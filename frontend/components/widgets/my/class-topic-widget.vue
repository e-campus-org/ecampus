<template>
    <v-card>
        <v-card-text>
            <p class="text-h5 font-weight-black">{{ currentTopic.title || "" }}</p>
        </v-card-text>
        <v-card-text>
            <tiptap-viewer :content="currentTopic.content" />
        </v-card-text>
    </v-card>
</template>
<script setup lang="ts">
import { TiptapViewer } from "@/components/shared";
defineProps<{
    loading: boolean;
    currentTopic: Classes.ReadClassLessonTopicInfoDTO;
}>();
</script>
