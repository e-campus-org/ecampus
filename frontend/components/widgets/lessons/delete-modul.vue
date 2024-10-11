<template>
    <v-dialog v-model="dialog" max-width="500px">
        <v-card>
            <v-card-title class="headline">{{ name.title }}</v-card-title>
            <v-card-text> {{ name.text }} "{{ item.title }}"? </v-card-text>
            <v-card-actions>
                <v-btn text @click="close">{{ name.cancel }}</v-btn>
                <v-btn text @click="remove">{{ name.delete }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from "vue";
import { useKeydownListener } from "@/composables/useKeydownListener";

const props = defineProps({
    modelValue: Boolean,
    item: Object,
    name: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(["update:modelValue", "delete"]);

const dialog = ref(false);

watch(
    () => props.modelValue,
    newVal => {
        dialog.value = newVal;
    }
);

watch(dialog, newVal => {
    emit("update:modelValue", newVal);
});

function close() {
    emit("update:modelValue", false);
}

function remove() {
    emit("delete", props.item);
    close();
}

useKeydownListener((event: KeyboardEvent) => {
    if (event.key === "Enter") {
        remove();
    }
});
</script>
