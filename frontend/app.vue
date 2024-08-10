<template>
    <nuxt-layout>
        <v-app>
            <nuxt-page />
        </v-app>
        <v-snackbar-queue v-model="queue" />
    </nuxt-layout>
</template>
<script setup lang="ts">
import { VSnackbarQueue } from "vuetify/labs/VSnackbarQueue";

const queue = ref<Common.Notification[]>([]);

function pushNotify(text: string, color: string = "primary") {
    queue.value.push({ text, color, timeout: 1500 });
}

useListen("notify:success", text => pushNotify(text, "success"));
useListen("notify:info", text => pushNotify(text, "info"));
useListen("notify:error", text => pushNotify(text, "error"));
</script>
