<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            :title="$t('components.widgets.groups.edit.createTitle')"
        >
            <v-form v-model="formIsValid">
                <v-card-text>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.title"
                            :label="$t('components.widgets.groups.edit.title')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.description"
                            :label="$t('components.widgets.groups.edit.description')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-select 
                                v-model="item.speciality_id"
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
                @click="onClose"
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
import { createDefaultGroupDTO } from '~/helpers/groupHelpers';

    const emit = defineEmits<{ 
        (e: 'add-confirm', item: Groups.CreateGroupDTO): void 
    }>();
    defineProps<{
        groupList: object[]
    }>();
    const dialog = defineModel<boolean>('dialog');

    const { t } = useI18n();
    const formIsValid = ref(false)
    const rules = [
        (v: string) => !!v || t('components.widgets.accounts.rules.default')
    ];
    const item = ref<Groups.CreateGroupDTO>(
        createDefaultGroupDTO()
    )

    const confirm = () => {
        emit('add-confirm', item.value)
        dialog.value = false
        item.value = createDefaultGroupDTO()
    }

    const onClose = () => {
        dialog.value = false
        item.value = createDefaultGroupDTO()
    }

</script>