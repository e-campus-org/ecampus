<template>
    <v-row>
        <v-col v-for="lesson in lessons" :key="lesson.id" cols="12" sm="6" md="4" lg="3">
            <v-card :loading="props.loading" :title="lesson.title" :subtitle="lesson.topic" :text="lesson.objectives">
                <v-card-actions>
                    <v-btn @click="emit('lesson-selected', lesson.id)">
                        {{ $t("components.widgets.my.showSubject") }}
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-col>
    </v-row>
    <div class="text-center">
        <v-pagination v-model="page" :length="pages" />
    </div>
</template>
<script setup lang="ts">
const props = defineProps<{
    loading: boolean;
    lessonsData: Shared.ListData<Lessons.ReadLessonDTO> | null;
}>();

const emit = defineEmits<{
    (e: "lesson-selected", subjectId: number): void;
    (e: "page-changed", page: number);
}>();

const lessons = computed(() => props.lessonsData?.list || []);

const page = computed({
    get: () => props.lessonsData?.pagination.page || 1,
    set: value => emit("page-changed", value)
});

const total = computed(() => props.lessonsData?.pagination.count || 0);
const pages = computed(() => props.lessonsData?.pagination.pages || 0);
</script>
