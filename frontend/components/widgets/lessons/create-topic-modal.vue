<template>
    <v-dialog v-model="dialog" max-width="600px">
        <v-card>
            <v-card-title class="headline">{{ $t("components.widgets.lessons.topics.edit.createTitle") }}</v-card-title>
            <v-card-text>
                <v-form ref="form" class="d-flex flex-column align-center ga-2">
                    <v-row class="w-100">
                        <v-col cols="12">
                            <v-text-field
                                v-model="title.value.value"
                                variant="underlined"
                                class="w-100"
                                clearable
                                :error-messages="title.errorMessage.value"
                                :label="$t('components.widgets.lessons.topics.headers.title')"
                                :loading="loading"
                                :disabled="loading"
                            />
                        </v-col>
                    </v-row>
                </v-form>
            </v-card-text>

            <v-card-actions>
                <v-btn text @click="close">{{ $t("components.widgets.lessons.modal.cancel") }}</v-btn>
                <v-btn @click="submit" :loading="loading"> 
                    {{ $t("components.widgets.lessons.action.add") }}
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from "vue";
import { useField, useForm } from "vee-validate";
import { useI18n } from "vue-i18n";

const props = defineProps<{
    topic: Lessons.ReadLessonTopicDTO | null;
    modelValue: boolean; 
    loading:boolean
    
}>();

const emit = defineEmits<{
    (e: "addTopic", lesson: Lessons.UpdateLessonTopicDTO | Lessons.CreateLessonTopicDTO): void;
    (e: "update:modelValue", value: boolean): void; 
}>();

const { t } = useI18n();
const dialog = ref(false); 

const { handleSubmit, resetForm } = useForm({
    initialValues: {
        title: "",
        content: "",
    },
    validationSchema: {
        title(v: string) {
            if (!v && props.topic) {
                return t("components.widgets.lessons.topics.edit.titleIsRequired");
            }
            return true;
        },
        content(_: string) {
            return true;
        }
    }
});

const title = useField<string>("title");

const submit = handleSubmit(values => {
    emit("addTopic", {
        title: values.title,
        content: values.content
    });
    dialog.value = false; 
});

function close() {
    emit("update:modelValue", false);
}

watch(
    () => props.modelValue,
    newValue => {
        dialog.value = newValue;
        if (newValue) {
            resetForm({
                values: {
                    title: "",
                    content: "",
                }
            });
        }
    }
);

watch(dialog, newVal => {
    emit("update:modelValue", newVal);
});
</script>
