<template>
    <div class="text-center pa-4">
        <v-dialog
        v-model="dialog"
        max-width="400"
        persistent
        >
        <v-card
            :text=text
            :title="$t('components.widgets.groups.edit.deleteTitle')"
        >
            <template #actions>
            <v-spacer />

            <v-btn @click="dialog = false">
                {{ $t('components.widgets.groups.edit.cancel') }}
            </v-btn>

            <v-btn  color="error" @click="onDelete">
                {{ $t('components.widgets.groups.edit.delete') }}
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
        item: Groups.ReadGroupDTO
    }>();

    const { t } = useI18n();
    const text = computed(() =>
        t('components.widgets.groups.edit.deleteText', {
            title: props.item.title
        }
    ))

    const onDelete = () => {
        emit('delete-confirm')
    }

</script>