<template>
    <div>
        <vuetify-tiptap markdownTheme="github" />
    </div>
</template>
<script setup lang="ts">
import { locale } from "vuetify-pro-tiptap";

locale.setLang("en");
</script>
<!-- <vuetify-tiptap
          v-model="content"
          label="Title"
          :hide-toolbar="hideToolbar"
          :disable-toolbar="disableToolbar"
          :outlined="outlined"
          :dense="dense"
          :error-messages="errorMessages"
          rounded
          :max-height="465"
          :max-width="maxWidth"
          :extensions="extensions"
        /> -->
