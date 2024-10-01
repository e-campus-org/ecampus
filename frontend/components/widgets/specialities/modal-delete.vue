<template>
    <div class="text-center pa-4">
        <v-dialog
        v-model="dialog"
        max-width="400"
        persistent
        >
        <v-card
            :text=text
            :title="$t('components.widgets.specialities.edit.deleteTitle')"
        >
            <template #actions>
            <v-spacer />

            <v-btn @click="dialog = false">
                {{ $t('components.widgets.specialities.edit.cancel') }}
            </v-btn>

            <v-btn  color="error" @click="onDelete">
                {{ $t('components.widgets.specialities.edit.delete') }}
            </v-btn>
            </template>
        </v-card>
        </v-dialog>
    </div>
</template>

<script setup lang="ts">
const { t } = useI18n();
const dialog = defineModel<boolean>('dialog')
const emit = defineEmits<{
    (e: "delete-confirm"): void;
}>()

const props = defineProps<{
    id: number | undefined
}>()

const text = computed(() =>
    t('components.widgets.specialities.edit.deleteText', {
        id: props.id
    }
))

const onDelete = () => {
    emit('delete-confirm')
}
</script>