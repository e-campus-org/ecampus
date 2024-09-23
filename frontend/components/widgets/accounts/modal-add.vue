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
            <v-card-text>
                <v-row dense>
                    <v-col>
                    <v-text-field
                        v-model="item.first_name"
                        label="First name*"
                        required
                    ></v-text-field>
                    </v-col>
                    <v-col>
                    <v-text-field
                        v-model="item.last_name"
                        label="Last name*"
                        required
                    ></v-text-field>
                    </v-col>
                </v-row>
                <v-row dense>
                    <v-col>
                        <v-select 
                            v-model="item.group_id"
                            :items="idList"
                            label="Group*"
                            required
                        />
                    </v-col>
                    <v-col>
                        <v-select 
                            v-model="item.roles"
                            :items="['student', 'admin']"
                            label="Role*"
                            required
                            multiple
                        />
                    </v-col>
                </v-row>
                <v-row dense>
                    <v-col>
                    <v-text-field
                        v-model="item.email"
                        label="Email*"
                        required
                    ></v-text-field>
                    </v-col>
                </v-row>
                <v-row dense>
                    <v-col>
                    <v-text-field
                        v-model="item.password"
                        label="Password*"
                        required
                    ></v-text-field>
                    </v-col>
                </v-row>
                <v-row dense>
                    <v-col>
                        <v-text-field
                            v-model="item.password_confirmation"
                            label="Password confirm*"
                            required
                        ></v-text-field>
                    </v-col>
                </v-row>
            </v-card-text>

            <v-divider></v-divider>

            <v-card-actions>
            <v-spacer></v-spacer>

            <v-btn
                text="Отмена"
                variant="plain"
                @click="dialog = false"
            ></v-btn>

            <v-btn
                color="primary"
                text="Создать"
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
const item = ref({})

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
</script>