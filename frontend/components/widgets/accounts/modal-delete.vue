<template>
    <div class="text-center pa-4">
        <v-dialog
            v-model="dialog"
            max-width="400"
            persistent
        >
        <v-card
            :text="text"
            :title="$t('components.widgets.accounts.edit.deleteTitle')"
        >
            <template v-slot:actions>
                <v-spacer></v-spacer>

                <v-btn @click="dialog = false">
                    {{ $t('components.widgets.accounts.edit.cancel') }}
                </v-btn>

                <v-btn  color="error" @click="onDelete">
                    {{ $t('components.widgets.accounts.edit.delete') }}
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
    const emit = defineEmits<{
        (e: "delete-confirm"): void;
    }>()

    const { t } = useI18n();
    const text = computed(() =>
        t('components.widgets.accounts.edit.deleteText',{
            firstName: props.item.first_name,
            lastName: props.item.last_name
        }
    ));
    
    const onDelete = () => {
        emit('delete-confirm')
    }
</script>