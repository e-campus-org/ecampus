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
                        v-model="editedItem.topic"
                        :label="headers.topic"
                        required
                        :error-messages="topicErrorMessages"
                    />
                    <v-text-field
                        v-model="editedItem.hours_count"
                        :label="headers.hours_count"
                        required
                        :error-messages="hours_countErrorMessages"
                    />

                    <v-select
                        v-model="editedItem.is_draft"
                        :items="selectItems"
                        :item-text="'text'"
                        :item-value="'value'"
                        persistent-hint
                        :hint="hint"
                        :label="headers.is_draft"
                        :error-messages="is_draftErrorMessages"
                    />
                    <v-text-field
                        v-model="editedItem.objectives"
                        :label="headers.objectives"
                        required
                        :error-messages="objectivesErrorMessages"
                    />
                    <v-text-field
                        v-model="editedItem.subject_id"
                        :label="headers.subject_id"
                        required
                        :error-messages="subject_idErrorMessages"
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
import { ref, reactive, watch, computed, onMounted } from "vue";
const { t } = useI18n();

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
const hint = computed(() => t("components.widgets.lessons.modal.hint"));

const selectItems = [t("components.widgets.lessons.draft.trueValue"), t("components.widgets.lessons.draft.falseValue")];

const correlate = {
    true: t("components.widgets.lessons.draft.trueValue"),
    false: t("components.widgets.lessons.draft.falseValue")
};

const dialog = ref(false);
const editedItem = reactive({
    id: null,
    title: "",
    topic: "",
    hours_count: "",
    is_draft: "",
    objectives: "",
    subject_id: ""
});

const titleErrorMessages = ref<string[]>([]);
const topicErrorMessages = ref<string[]>([]);
const hours_countErrorMessages = ref<string[]>([]);
const is_draftErrorMessages = ref<string[]>([]);
const objectivesErrorMessages = ref<string[]>([]);
const subject_idErrorMessages = ref<string[]>([]);

const titleInput = ref<HTMLInputElement | null>(null);

watch(
    () => props.modelValue,
    newVal => {
        dialog.value = newVal;
        if (newVal && props.item) {
            editedItem.id = props.item.id;
            editedItem.title = props.item.title;
            editedItem.topic = props.item.topic;
            editedItem.hours_count = props.item.hours_count;
            editedItem.is_draft = props.item.is_draft;
            editedItem.objectives = props.item.objectives;
            editedItem.subject_id = props.item.subject_id;

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
    topicErrorMessages.value = [];
    hours_countErrorMessages.value = [];
    is_draftErrorMessages.value = [];
    objectivesErrorMessages.value = [];
    subject_idErrorMessages.value = [];

    let isValid = true;

    if (!editedItem.title) {
        titleErrorMessages.value.push(props.err.title || "Title is required.");
        isValid = false;
    }
    if (!editedItem.topic) {
        topicErrorMessages.value.push(props.err.topic || "Topic is required.");
        isValid = false;
    }
    if (!editedItem.hours_count) {
        hours_countErrorMessages.value.push(props.err.hours_count || "Hours_count is required.");
        isValid = false;
    }
    if (!editedItem.is_draft) {
        is_draftErrorMessages.value.push(props.err.is_draft || "Is_draft is required.");
        isValid = false;
    }
    if (!editedItem.objectives) {
        objectivesErrorMessages.value.push(props.err.objectives || "Objectives is required.");
        isValid = false;
    }
    if (!editedItem.subject_id) {
        subject_idErrorMessages.value.push(props.err.subject_id || "Subject_id is required.");
        isValid = false;
    }

    return isValid;
}

function save() {
    if (validateInputs()) {
        const itemToSave = { ...editedItem };

        const key = Object.keys(correlate).find(key => correlate[key] === itemToSave.is_draft);

        if (key) {
            itemToSave.is_draft = key;
        }

        emit("save", itemToSave);
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
