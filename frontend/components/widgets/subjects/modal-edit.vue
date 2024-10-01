<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            :title="$t('components.widgets.subjects.edit.editTitle')"
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
                @click="dialog = false"
            ></v-btn>

            <v-btn
                color="primary"
                :text="$t('components.widgets.subjects.edit.save')"
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
    const rules = [(v: string) => !!v || t('components.widgets.accounts.rules.default')];
    const formIsValid = ref(false)
    const emit = defineEmits<{ 
        (e: 'edit-confirm', item: object): void 
    }>()

    const props = defineProps<{
        item: Subjects.ReadSubjectDTO
    }>()

    const localItem = reactive({ 
        title: '',
        short_title: '',
        prerequisites: '',
        objectives: '',
        required_texts: '',
        description: ''
    });

    watch(() => props.item, (newItem) => {
        Object.assign(localItem, newItem);
    }, { deep: true, immediate: true });


    const confirm = () => {
        emit('edit-confirm', localItem)
    }


</script>