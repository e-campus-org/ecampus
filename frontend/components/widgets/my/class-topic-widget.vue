<template>
    <v-card>
        <v-card-text>
            <p class="text-h5 font-weight-black">{{ currentTopic.title || "" }}</p>
        </v-card-text>
        <v-card-text>
            <client-only>
                <vuetify-viewer :value="currentTopic.content" />
            </client-only>
        </v-card-text>
    </v-card>
</template>
<script setup lang="ts">
defineProps<{
    loading: boolean;
    currentTopic: Classes.ReadClassLessonTopicInfoDTO;
}>();
</script>
