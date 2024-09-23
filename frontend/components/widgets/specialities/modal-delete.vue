<template>
    <div class="text-center pa-4">
        <v-dialog
        v-model="dialog"
        max-width="400"
        persistent
        >
        <v-card
            :text=text
            title="Подтверждение"
        >
            <template #actions>
            <v-spacer />

            <v-btn @click="dialog = false">
                Назад
            </v-btn>

            <v-btn  color="error" @click="onDelete">
                Удалить
            </v-btn>
            </template>
        </v-card>
        </v-dialog>
    </div>
</template>

<script setup lang="ts">
const dialog = defineModel<boolean>('dialog')
const emit = defineEmits<{
    (e: "delete-confirm"): void;
}>()

const props = defineProps<{
    id: number | undefined
}>()

const text = computed(() =>
    (`Вы действительно хотите удалить ${props.id} специальность?`)
)

const onDelete = () => {
    emit('delete-confirm')
}
</script>