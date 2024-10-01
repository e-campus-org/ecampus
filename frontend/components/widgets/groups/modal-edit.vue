<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            :title="$t('components.widgets.groups.edit.editTitle')"
        >
            <v-form v-model="formIsValid">
                <v-card-text>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="localItem.title"
                            :label="$t('components.widgets.groups.edit.title')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="localItem.description"
                            :label="$t('components.widgets.groups.edit.description')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-select 
                                v-model="localItem.speciality_id"
                                :items="groupList"
                                item-value="id"
						        item-title="title"
                                :label="$t('components.widgets.groups.edit.specialityId')"
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
                :text="$t('components.widgets.groups.edit.cancel')"
                variant="plain"
                @click="dialog = false"
            ></v-btn>

            <v-btn
                color="primary"
                :text="$t('components.widgets.groups.edit.create')"
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
        groupList: object[],
        item: Groups.ReadGroupDTO
    }>()


    const localItem = reactive({ 
        title: '',
        speciality_id: '',
        description: ''
    });

    watch(() => props.item, (newItem) => {
            Object.assign(localItem, newItem);
        }, { deep: true, immediate: true });


    const confirm = () => {
        emit('edit-confirm', localItem)
    }


</script>