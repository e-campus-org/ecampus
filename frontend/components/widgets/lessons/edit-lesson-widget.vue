<template>
    <v-form ref="form" class="d-flex flex-column align-center ga-2" @submit.prevent="submit">
        <v-row>
            <v-col cols="12">
                <h3 class="text-h3">
                    {{
                        lesson
                            ? $t("components.widgets.lessons.edit.editTitle")
                            : $t("components.widgets.lessons.edit.createTitle")
                    }}
                </h3>
            </v-col>
        </v-row>
        <v-row class="w-100">
            <v-col cols="12">
                <v-select
                    class="w-100"
                    :label="$t('components.widgets.lessons.headers.subjectId')"
                    :items="subjectItems"
                    item-value="id"      
                    item-text="title"     
                    v-model="subject.value.value"
                    :error-messages="subject.errorMessage.value"
                    :loading="loading"
                    :disabled="loading"
                />
            </v-col>

            <v-col cols="12">
                <v-text-field
                    v-model="title.value.value"
                    class="w-100"
                    clearable
                    :error-messages="title.errorMessage.value"
                    :label="$t('components.widgets.lessons.headers.title')"
                    :loading="loading"
                    :disabled="loading"
                />
            </v-col>
            <v-col cols="12">
                <v-text-field
                    v-model="topic.value.value"
                    class="w-100"
                    clearable
                    :error-messages="topic.errorMessage.value"
                    :label="$t('components.widgets.lessons.headers.topic')"
                    :loading="loading"
                    :disabled="loading"
                />
            </v-col>
            <v-col cols="12" sm="6" md="4" lg="3">
                <v-text-field
                    v-model="hours.value.value"
                    class="w-100"
                    clearable
                    :error-messages="hours.errorMessage.value"
                    :label="$t('components.widgets.lessons.headers.hoursCount')"
                    :loading="loading"
                    :disabled="loading"
                />
            </v-col>
            <v-col cols="12" sm="6" md="4" lg="3">
                <v-checkbox
                    v-model="draft.value.value"
                    class="w-100"
                    clearable
                    :error-messages="draft.errorMessage.value"
                    :label="$t('components.widgets.lessons.headers.isDraft')"
                    :loading="loading"
                    :disabled="loading"
                />
            </v-col>
        </v-row>
        <v-btn class="mt-4" type="submit" :loading="loading">
            {{ $t("components.widgets.lessons.edit.save") }}
        </v-btn>
    </v-form>
</template>
<script setup lang="ts">
import { useField, useForm } from "vee-validate";
import { computed, watch } from 'vue';

const props = defineProps<{
    lesson: Lessons.ReadLessonDTO | null;
    loading: boolean;
    subjects: ListData<ReadSubjectDTO> | null;
}>();

const emit = defineEmits<{
    (e: "lesson-changed", lesson: Lessons.UpdateLessonDTO | Lessons.CreateLessonDTO): void;
}>();

const { t } = useI18n();

const { handleSubmit, resetForm } = useForm({
    initialValues: {
        subject: "",     
        title: "",
        topic: "",
        hours: "2",
        draft: true
    },
    validationSchema: {
        subject(v: string) {
            if (!v && props.lesson) {
                return t("components.widgets.lessons.edit.subjectIsRequired");
            }
            if (!/^\d+$/.test(v)) {
                return t("components.widgets.lessons.edit.wrongSubject");
            }
            return true;
        },
        title(v: string) {
            if (!v && props.lesson) {
                return t("components.widgets.lessons.edit.titleIsRequired");
            }
            return true;
        },
        topic(v: string) {
            if (!v && props.lesson) {
                return t("components.widgets.lessons.edit.topicIsRequired");
            }
            return true;
        },
        draft(_: string) {
            return true;
        },
        hours(v: number) {
            if (!/^\d+$/.test(v + "")) {
                return t("components.widgets.lessons.edit.wrongHours");
            }
            return true;
        }
    }
});

const subjectItems = computed(() => {
    return props.subjects?.list?.map(subject => ({
        id: subject.id,
        title: subject.title  
    })) || [];
});

const subject = useField("subject");
const title = useField("title");
const topic = useField("topic");
const draft = useField("draft");
const hours = useField("hours");

const submit = handleSubmit(values => {
    emit("lesson-changed", {
        subject_id: parseInt(values.subject, 10), 
        title: values.title,
        topic: values.topic,
        hours_count: parseInt(values.hours, 10),
        is_draft: values.draft
    });
});

watch(
    () => props.lesson,
    newValue => {
        if (newValue ) {
            setTimeout(()=>{ 
            const selectedSubject = subjectItems.value.find(item => item.id == newValue.subject_id);
            resetForm({
                values: {
                    subject: selectedSubject ? selectedSubject.title.toString() : "", 
                    title: newValue.title || "",
                    topic: newValue.topic || "",
                    hours: newValue.hours_count?.toString() || "2",
                    draft: newValue.is_draft || true
                }
                });
            },200)
           
        }
    }
);
</script>
