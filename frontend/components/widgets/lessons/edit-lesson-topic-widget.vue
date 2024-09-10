<template>
    <v-form ref="form" class="d-flex flex-column align-center ga-2" @submit.prevent="submit">
        <v-row>
            <v-col cols="12">
                <h3 class="text-h3">
                    {{
                        topic
                            ? $t("components.widgets.lessons.topics.edit.editTitle")
                            : $t("components.widgets.lessons.topics.edit.createTitle")
                    }}
                </h3>
            </v-col>
        </v-row>
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
            <v-col cols="12">
                <client-only>
                    <vuetify-tiptap
                        v-model="content.value.value"
                        :disabled="loading"
                        :disable-toolbar="loading"
                        output="json"
                    />
                </client-only>
            </v-col>
        </v-row>
        <v-btn class="mt-4" type="submit" :loading="loading">
            {{ $t("components.widgets.lessons.edit.save") }}
        </v-btn>
    </v-form>
</template>
<script setup lang="ts">
import { useField, useForm } from "vee-validate";

/**
 * :hide-toolbar="hideToolbar"
          :disable-toolbar="disableToolbar"
          :outlined="outlined"
          :dense="dense"
          :error-messages="errorMessages"
          rounded
          :max-height="465"
          :max-width="maxWidth"
          :extensions="extensions"
 */

const props = defineProps<{
    topic: Lessons.ReadLessonTopicDTO | null;
    loading: boolean;
}>();

const emit = defineEmits<{
    (e: "lesson-topic-changed", lesson: Lessons.UpdateLessonTopicDTO | Lessons.CreateLessonTopicDTO): void;
}>();

const { t } = useI18n();

const { handleSubmit, resetForm } = useForm({
    initialValues: {
        title: "",
        content: "",
        description: ""
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
const content = useField<string>("content");

const submit = handleSubmit(values => {
    emit("lesson-topic-changed", {
        title: values.title,
        content: values.content
    });
});

watch(
    () => props.topic,
    newValue => {
        if (newValue) {
            resetForm({
                values: {
                    title: newValue?.title || "",
                    content: newValue?.content || "",
                    description: newValue?.description || ""
                }
            });
        }
    }
);
</script>
