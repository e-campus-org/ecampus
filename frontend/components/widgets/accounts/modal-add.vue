<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            title="Новый пользователь"
        >
            <v-form v-model="formIsValid">
                <v-card-text>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.first_name"
                            label="First name*"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                        <v-col>
                        <v-text-field
                            v-model="item.last_name"
                            label="Last name*"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-select 
                                v-model="item.group_id"
                                :items="idList"
                                label="Group*"
                            />
                        </v-col>
                        <v-col>
                            <v-select 
                                v-model="item.roles"
                                :items="['student', 'admin']"
                                label="Role*"
                                multiple
                                :rules="rules"
                            />
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.email"
                            label="Email*"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.password"
                            label="Password*"
                            :rules="rules"
                            type="password"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-text-field
                                v-model="item.password_confirmation"
                                label="Password confirm*"
                                :rules="rules"
                                type="password"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                </v-card-text>
            </v-form>

            <v-divider></v-divider>

            <v-card-actions>
            <v-spacer></v-spacer>

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
const item = ref({})
const rules = [value => !!value || 'Обязательное поле']
const formIsValid = ref(false)

defineProps<{
    idList: number[]
}>()

const emit = defineEmits<{ 
    (e: 'add-confirm', item: object): void 
}>()

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