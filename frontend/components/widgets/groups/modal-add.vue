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
            <v-form v-model="formIsValid">
                <v-card-text>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.title"
                            label="Title*"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.description"
                            label="Description*"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-select 
                                v-model="item.speciality_id"
                                :items="idList"
                                label="Speciality id"
                                :rules="rules"
                            />
                        </v-col>
                    </v-row>
                </v-card-text>
            </v-form>

            <v-divider />

            <v-card-actions>
            <v-spacer />

            <v-btn
                text="Отмена"
                variant="plain"
                @click="onClose"
            ></v-btn>

            <v-btn
                color="primary"
                text="Создать"
                variant="tonal"
                :disabled="!formIsValid"
                @click="confirm"
            ></v-btn>
            </v-card-actions>
        </v-card>
        </v-dialog>
    </div>
</template>

<script setup lang="ts">
const dialog = defineModel<boolean>('dialog')
const formIsValid = ref(false)
const rules = [value => !!value || 'Обязательное поле']
const emit = defineEmits<{ 
    (e: 'add-confirm', item: object): void 
}>()

defineProps<{
    idList: number[]
}>()

const item = ref({})

const confirm = () => {
    emit('add-confirm', item.value)
    dialog.value = false
    item.value = {}
}

const onClose = () => {
    dialog.value = false
    item.value = {}
}

</script>