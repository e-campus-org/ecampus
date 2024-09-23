<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            title="User Profile"
        >
            <v-card-text>
            <v-row dense>
                <v-col>
                <v-text-field
                    v-model="localItem.title"
                    label="Title*"
                    required
                ></v-text-field>
                </v-col>
            </v-row>
            <v-row dense>
                <v-col>
                <v-text-field
                    v-model="localItem.description"
                    label="Description*"
                    required
                ></v-text-field>
                </v-col>
            </v-row>
            <v-row dense>
                <v-col>
                    <v-select 
                        v-model="localItem.speciality_id"
                        :items="idList"
                        label="Speciality id"
                        required
                    />
                </v-col>
            </v-row>
            </v-card-text>

            <v-divider />

            <v-card-actions>
            <v-spacer />

            <v-btn
                text="Отмена"
                variant="plain"
                @click="dialog = false"
            ></v-btn>

            <v-btn
                color="primary"
                text="Изменить"
                variant="tonal"
                @click="confirm"
            ></v-btn>
            </v-card-actions>
        </v-card>
        </v-dialog>
    </div>
</template>

<script setup lang="ts">
const dialog = defineModel<boolean>('dialog')
const emit = defineEmits<{ 
    (e: 'edit-confirm', item: object): void 
}>()

const props = defineProps<{
    idList: number[],
    item: Groups.ReadGroupDTO
}>()

const localItem = reactive({ 
    title: props.item.title,
    speciality_id: props.item.speciality_id,
    description: props.item.description
});

watch(() => props.item, (newItem) => {
    localItem.title = newItem.title;
    localItem.speciality_id = newItem.speciality_id;
    localItem.description = newItem.description;
});


const confirm = () => {
    emit('edit-confirm', localItem)
}


</script>