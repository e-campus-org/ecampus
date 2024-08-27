<template>
    <v-row>
        <v-col v-for="subject in props.subjects" :key="subject.id" cols="12" sm="6" md="4" lg="3">
            <v-card
                :loading="props.loading"
                :title="subject.short_title"
                :subtitle="subject.title"
                :text="subject.description"
            >
                <v-card-actions>
                    <v-btn>{{ $t("components.widgets.my.showSubject") }}</v-btn>
                </v-card-actions>
            </v-card>
        </v-col>
    </v-row>
</template>
<script setup lang="ts">
const props = defineProps<{
    loading: boolean;
    subjects: Subjects.ReadSubjectDTO[];
}>();
</script>
