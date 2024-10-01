<template>
    <div class="text-center pa-4">
        <v-dialog
        v-model="dialog"
        max-width="400"
        persistent
        >
        <v-card
            :text="text"
            :title="$t('components.widgets.subjects.edit.deleteTitle')"
        >
            <template v-slot:actions>
                <v-spacer></v-spacer>

                <v-btn @click="dialog = false">
                    {{ $t('components.widgets.subjects.edit.cancel') }}
                </v-btn>

                <v-btn  color="error" @click="onDelete">
                    {{ $t('components.widgets.subjects.edit.delete') }}
                </v-btn>
            </template>
        </v-card>
        </v-dialog>
    </div>
</template>

<script setup lang="ts">
    const { t } = useI18n();
    const dialog = defineModel<boolean>('dialog')
    const props = defineProps<{
        item: Subjects.ReadSubjectDTO
    }>()

    const text = computed(() =>
        t('components.widgets.specialities.edit.deleteText', {
            title: props.item.title
        }))
        
    const emit = defineEmits<{
        (e: "delete-confirm"): void;
    }>()

    const onDelete = () => {
        emit('delete-confirm')
    }
</script>