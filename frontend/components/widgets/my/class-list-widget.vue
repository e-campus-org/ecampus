<template>
    <v-row>
        <v-col v-for="cls in classes" :key="cls.id" cols="12" sm="6" md="4" lg="3">
            <v-card :loading="props.loading" :title="cls.lesson.title" :subtitle="cls.lesson.topic">
                <v-card-actions>
                    <v-btn @click="emit('class-selected', cls.id)">
                        {{ $t("components.widgets.my.goToClass") }}
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
    classesData: Shared.ListData<Classes.ReadClassDTO> | null;
}>();

const emit = defineEmits<{
    (e: "class-selected" | "page-changed", value: number): void;
}>();

const classes = computed(() => props.classesData?.list || []);

const page = computed({
    get: () => props.classesData?.pagination.page || 1,
    set: value => emit("page-changed", value)
});

const pages = computed(() => props.classesData?.pagination.pages || 0);
</script>
