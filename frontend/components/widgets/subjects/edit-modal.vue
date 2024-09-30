<template>
    <v-dialog v-model="dialog" max-width="500px">
        <v-card>
            <v-card-title class="headline">{{ name.title }}</v-card-title>
            <v-card-text>
                <v-form ref="editForm" @keydown.enter.prevent="submitOnEnter">
                    <v-text-field
                        v-model="editedItem.title"
                        :label="headers.title"
                        required
                        ref="titleInput"
                        :error-messages="titleErrorMessages"
                    />
                    <v-text-field
                        v-model="editedItem.shortTitle"
                        :label="headers.shortTitle"
                        required
                        :error-messages="shortTitleErrorMessages"
                    />
                    <v-text-field
                        v-model="editedItem.description"
                        :label="headers.description"
                        required
                        :error-messages="descriptionErrorMessages"
                    />
                    <v-text-field
                        v-model="editedItem.objectives"
                        :label="headers.objectives"
                        required
                        :error-messages="objectivesErrorMessages"
                    />
                    <v-text-field
                        v-model="editedItem.prerequisites"
                        :label="headers.prerequisites"
                        required
                        :error-messages="prerequisitesErrorMessages"
                    />
                    <v-text-field
                        v-model="editedItem.requiredTexts"
                        :label="headers.requiredTexts"
                        required
                        :error-messages="requiredTextsErrorMessages"
                    />
                </v-form>
            </v-card-text>
            <v-card-actions>
                <v-btn text @click="close">{{ name.cancel }}</v-btn>
                <v-btn text @click="save">{{ name.save }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch, onMounted } from "vue";

const props = defineProps({
    modelValue: Boolean,
    item: Object,
    headers: {
        type: Object,
        required: true
    },
    name: {
        type: Object,
        required: true
    },
    err: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(["update:modelValue", "save"]);

const dialog = ref(false);
const editedItem = reactive({
    id: null,
    title: "",
    shortTitle: "",
    description: "",
    objectives: "",
    prerequisites: "",
    requiredTexts: ""
});

const titleErrorMessages = ref<string[]>([]);
const shortTitleErrorMessages = ref<string[]>([]);
const descriptionErrorMessages = ref<string[]>([]);
const objectivesErrorMessages = ref<string[]>([]);
const prerequisitesErrorMessages = ref<string[]>([]);
const requiredTextsErrorMessages = ref<string[]>([]);

const titleInput = ref<HTMLInputElement | null>(null);

watch(
    () => props.modelValue,
    newVal => {
        dialog.value = newVal;
        if (newVal && props.item) {
            editedItem.id = props.item.id;
            editedItem.title = props.item.title;
            editedItem.shortTitle = props.item.short_title;
            editedItem.description = props.item.description;
            editedItem.objectives = props.item.objectives;
            editedItem.prerequisites = props.item.prerequisites;
            editedItem.requiredTexts = props.item.required_texts;

            setTimeout(() => {
                titleInput.value?.focus();
            }, 10);
        }
    }
);

watch(dialog, newVal => {
    emit("update:modelValue", newVal);
});

function close() {
    emit("update:modelValue", false);
}

function validateInputs() {
    titleErrorMessages.value = [];
    shortTitleErrorMessages.value = [];
    descriptionErrorMessages.value = [];
    objectivesErrorMessages.value = [];
    prerequisitesErrorMessages.value = [];
    requiredTextsErrorMessages.value = [];

    let isValid = true;

    if (!editedItem.title) {
        titleErrorMessages.value.push(props.err.title || "Title is required.");
        isValid = false;
    }
    if (!editedItem.shortTitle) {
        shortTitleErrorMessages.value.push(props.err.shortTitle || "Code is required.");
        isValid = false;
    }
    if (!editedItem.description) {
        descriptionErrorMessages.value.push(props.err.description || "Description is required.");
        isValid = false;
    }
    if (!editedItem.objectives) {
        objectivesErrorMessages.value.push(props.err.objectives || "Objectives is required.");
        isValid = false;
    }
    if (!editedItem.prerequisites) {
        prerequisitesErrorMessages.value.push(props.err.prerequisites || "Prerequisites is required.");
        isValid = false;
    }
    if (!editedItem.requiredTexts) {
        requiredTextsErrorMessages.value.push(props.err.requiredTexts || "RequiredTexts is required.");
        isValid = false;
    }

    return isValid;
}

function save() {
    if (validateInputs()) {
        emit("save", { ...editedItem });
        close();
    }
}

function submitOnEnter() {
    save();
}

onMounted(() => {
    if (dialog.value) {
        setTimeout(() => {
            titleInput.value?.focus();
        }, 10);
    }
});
</script>
