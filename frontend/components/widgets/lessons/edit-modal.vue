<template>
    <v-dialog v-model="dialog" max-width="600px">
        <v-card>
            <v-card-title class="headline">{{ dynamicTitle }}</v-card-title>
            <v-card-text>
                <v-window v-model="step">
                    <v-window-item :value="0">
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
                                v-model="editedItem.subject_id"
                                :label="headers.subject_id"
                                required
                                :error-messages="subject_idErrorMessages"
                            />
                        </v-form>
                    </v-window-item>

                    <v-window-item
                        v-for="(question, index) in editedItem.questions"
                        :key="index"
                        :value="index + 1"
                    >
                        <v-card-text>
                            <v-text-field
                                v-model="question.title"
                                :label="`title ${index + 1}`"
                                :error-messages="questionErrorMessages[index]?.title"
                            />
                            <v-text-field
                                v-model="question.description"
                                :label="`description ${index + 1}`"
                                :error-messages="questionErrorMessages[index]?.description"
                            />
                            <v-text-field
                                v-model="question.objectives"
                                :label="`objectives ${index + 1}`"
                                :error-messages="questionErrorMessages[index]?.objectives"
                            />
                            
                            <v-btn icon @click="removeQuestion(index)">
                                <v-icon>mdi-delete</v-icon>
                            </v-btn>
                        </v-card-text>
                    </v-window-item>

                </v-window>
            </v-card-text>
            
            <v-card-actions>
                <v-btn text @click="close">{{ name.cancel }}</v-btn>
                <v-btn text @click="previousStep" :disabled="step === 0">{{ back }}</v-btn>
                <v-btn text @click="nextStep" v-if="step < editedItem?.questions?.length">{{ next }}</v-btn>
                <v-btn text @click="addQuestion" v-if="step === editedItem?.questions?.length">{{ createTitle }}</v-btn>
                <v-btn text @click="save" v-if="step === editedItem?.questions?.length">{{ name.save }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch, computed, onMounted } from "vue";
const { t } = useI18n();

const step = ref(0); 

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

const emit = defineEmits(["update:modelValue", "save", "questions-delete"]);
const hint = computed(() => t("components.widgets.lessons.modal.hint"));

const createTitle = t("components.widgets.lessons.topics.edit.createTitle");
const next = t("components.widgets.lessons.topics.edit.next");
const back = t("components.widgets.lessons.topics.edit.back");

const selectItems = [t("components.widgets.lessons.draft.trueValue"), t("components.widgets.lessons.draft.falseValue")];

const dialog = ref(false);
const editedItem = reactive({
    id: null,
    title: "",
    topic: "",
    hours_count: "",
    is_draft: "",
    objectives: "",
    subject_id: "",
    questions: []
});

const titleErrorMessages = ref<string[]>([]);
const topicErrorMessages = ref<string[]>([]);
const hours_countErrorMessages = ref<string[]>([]);
const is_draftErrorMessages = ref<string[]>([]);
const objectivesErrorMessages = ref<string[]>([]);
const subject_idErrorMessages = ref<string[]>([]);

const titleInput = ref<HTMLInputElement | null>(null);
const questionErrorMessages = ref<{ title: string[], description: string[], objectives: string[] }[]>([]);

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
            editedItem.questions = props.item.questions


            setTimeout(() => {
                titleInput.value?.focus();
            }, 10);
        }
    }
);

watch(dialog, newVal => {
    emit("update:modelValue", newVal);
});

const dynamicTitle = computed(() => {
    return step.value === 0 
        ? t("components.widgets.lessons.modal.edit_title") 
        : `${t("components.widgets.lessons.topics.edit.editTitle")} ${step.value}`;
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
    questionErrorMessages.value = []; 

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
    if (!editedItem.subject_id) {
        subject_idErrorMessages.value.push(props.err.subject_id || "Subject_id is required.");
        isValid = false;
    }

    editedItem.questions.forEach((question, index) => {
        const errors = {
            title: [],
            description: [],
            objectives: []
        };

        if (!question.title) {
            errors.title.push(`${props.err.question_title} ` + (index + 1));
            isValid = false;
        }
        if (!question.description) {
            errors.description.push(`${props.err.question_description} ` + (index + 1));
            isValid = false;
        }
        if (!question.objectives) {
            errors.objectives.push(`${props.err.question_objectives} ` + (index + 1));
            isValid = false;
        }

        questionErrorMessages.value.push(errors);
    });

    return isValid;
}

function save() {
    if (validateInputs()) {
        emit("save", { ...editedItem });
        close();
    }
}

function addQuestion() {
    editedItem.questions.push({
        title: "",
        description: "",
        objectives: "",
        content: {},
        lesson_id: editedItem?.subject_id
    });
    step.value = editedItem.questions.length;
}

function removeQuestion(index: number) {
    emit("questions-delete",  editedItem.questions[index].id )
    editedItem.questions.splice(index, 1);
    if (step.value > editedItem.questions.length) {
        step.value = editedItem.questions.length;
    }
}

function previousStep() {
    if (step.value > 0) step.value--;
}

function nextStep() {
    if (step.value < editedItem.questions.length) step.value++;
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
