<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            :title="$t('components.widgets.subjects.edit.createTitle')"
        >
            <v-form v-model="formIsValid">
                <v-card-text>
                    <v-row dense>
                        <v-col>
                            <v-text-field
                                v-model="item.title"
                                :label="$t('components.widgets.subjects.edit.title')"
                                :rules="rules"
                            ></v-text-field>
                        </v-col>
                        <v-col>
                            <v-text-field
                                v-model="item.short_title"
                                :label="$t('components.widgets.subjects.edit.shortTitle')"
                                :rules="rules"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-text-field
                                v-model="item.prerequisites"
                                :label="$t('components.widgets.subjects.edit.prerequisites')"
                                :rules="rules"
                            ></v-text-field>
                        </v-col>
                        <v-col>
                            <v-text-field
                                v-model="item.objectives"
                                :label="$t('components.widgets.subjects.edit.objectives')"
                                :rules="rules"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-text-field
                                v-model="item.required_texts"
                                :label="$t('components.widgets.subjects.edit.requiredTexts')"
                                :rules="rules"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-select 
                                v-model="item.teachers"
                                :items="teachersList"
                                :label="$t('components.widgets.subjects.edit.teachers')"
                                multiple
                            />
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-text-field
                                v-model="item.description"
                                :label="$t('components.widgets.subjects.edit.description')"
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
                :text="$t('components.widgets.subjects.edit.cancel')"
                variant="plain"
                @click="onClose"
            ></v-btn>

            <v-btn
                color="primary"
                :text="$t('components.widgets.subjects.edit.create')"
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
    import { createDefaultSubjectDTO } from '~/helpers/subjectHelpers';

    const dialog = defineModel<boolean>('dialog')
    const emit = defineEmits<{ 
        (e: 'add-confirm', item: Subjects.CreateSubjectDTO): void 
    }>()

    const { t } = useI18n();
    const item = ref<Subjects.CreateSubjectDTO>(
        createDefaultSubjectDTO()
    )
    const teachersList = ref([])
    const formIsValid = ref(false)
    const rules = [
        (v: string) => !!v || t('components.widgets.accounts.rules.default')
    ];

    const confirm = () => {
        emit('add-confirm', item.value)
        dialog.value = false
        item.value = createDefaultSubjectDTO()
    }

    const onClose = () => {
        dialog.value = false
        item.value = createDefaultSubjectDTO()
    }

</script>