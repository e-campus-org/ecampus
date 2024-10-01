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
    import { updateDefaultGroupDTO } from '~/helpers/groupHelpers';

    const emit = defineEmits<{ 
        (e: 'edit-confirm', item: object): void 
    }>();
    const props = defineProps<{
        groupList: object[],
        item: Groups.ReadGroupDTO
    }>();
    const dialog = defineModel<boolean>('dialog');

    const { t } = useI18n();
    const rules = [
        (v: string) => !!v || t('components.widgets.accounts.rules.default')
    ];
    const formIsValid = ref(false);
    const localItem = ref<Groups.UpdateGroupDTO>(
        updateDefaultGroupDTO()
    )

    watch(
      () => props.item, 
      (newItem) => {
        localItem.value = updateDefaultGroupDTO(newItem)
      }, 
      { immediate: true }
    );


    const confirm = () => {
        emit('edit-confirm', localItem.value)
    }


</script>