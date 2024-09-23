<template>
    <div class="text-center pa-4">
        <v-dialog
        v-model="dialog"
        max-width="400"
        persistent
        >
        <v-card
            :text="text"
            title="Подтверждение"
        >
            <template v-slot:actions>
                <v-spacer></v-spacer>

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
    const props = defineProps<{
    item: Accounts.ReadAccountDTO
}>()

const text = computed(() =>
    (`Вы действительно хотите удалить ${props.item.first_name} ${props.item.last_name}?`)
)
const emit = defineEmits<{
    (e: "delete-confirm"): void;
}>()

const onDelete = () => {
    emit('delete-confirm')
}
</script>