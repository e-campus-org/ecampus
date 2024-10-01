<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            :title="$t('components.widgets.specialities.edit.createTitle')"
        >
            <v-form v-model="formIsValid">
                <v-card-text>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.title"
                            :label="$t('components.widgets.specialities.edit.title')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.code"
                            :label="$t('components.widgets.specialities.edit.code')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.description"
                            :label="$t('components.widgets.specialities.edit.description')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                </v-card-text>
            </v-form>

            <v-divider />

            <v-card-actions>
            <v-spacer />

            <v-btn
                :text="$t('components.widgets.specialities.edit.cancel')"
                variant="plain"
                @click="onClose"
            ></v-btn>

            <v-btn
                color="primary"
                :text="$t('components.widgets.specialities.edit.create')"
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
const { t } = useI18n();
const dialog = defineModel<boolean>('dialog')
const formIsValid = ref(false)
const rules = [(v: string) => !!v || t('components.widgets.accounts.rules.default')];
const emit = defineEmits<{ 
    (e: 'add-confirm', item: object): void 
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