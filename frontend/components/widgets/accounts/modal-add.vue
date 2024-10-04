<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            :title="$t('components.widgets.accounts.edit.createTitle')"
        >
            <v-form v-model="formIsValid">
                <v-card-text>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.first_name"
                            :label="$t('components.widgets.accounts.edit.firstName')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                        <v-col>
                        <v-text-field
                            v-model="item.last_name"
                            :label="$t('components.widgets.accounts.edit.lastName')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-select 
                                v-model="item.group_id"
                                :items="groupList"
                                item-value="id"
						        item-title="title"
                                :label="$t('components.widgets.accounts.edit.group')"
                            />
                        </v-col>
                        <v-col>
                            <v-select 
                                v-model="item.roles"
                                :items="['student', 'admin', 'teacher']"
                                :label="$t('components.widgets.accounts.edit.roles')"
                                multiple
                                :rules="rules"
                            />
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                        <v-text-field
                            v-model="item.email"
                            :label="$t('components.widgets.accounts.edit.email')"
                            :rules="rules"
                        ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-text-field
                                v-model="item.password"
                                :append-inner-icon="visiblePassword ? 'mdi-eye-off' : 'mdi-eye'"
                                :type="visiblePassword ? 'text' : 'password'"
                                :label="$t('components.widgets.accounts.edit.password')"
                                :rules="passwordRules"
                                @click:append-inner="visiblePassword = !visiblePassword"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row dense>
                        <v-col>
                            <v-text-field
                                v-model="item.password_confirmation"
                                :append-inner-icon="visiblePasswordConfirm ? 'mdi-eye-off' : 'mdi-eye'"
                                :type="visiblePasswordConfirm ? 'text' : 'password'"
                                :label="$t('components.widgets.accounts.edit.passwordConfirm')"
                                :rules="passwordConfirmRules"
                                @click:append-inner="visiblePasswordConfirm = !visiblePasswordConfirm"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                </v-card-text>
            </v-form>

            <v-divider></v-divider>

            <v-card-actions>
            <v-spacer></v-spacer>

            <v-btn
                :text="$t('components.widgets.accounts.edit.cancel')"
                variant="plain"
                @click="onClose"
            ></v-btn>

            <v-btn
                color="primary"
                :text="$t('components.widgets.accounts.edit.create')"
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
    import { createDefaultAccountDTO } from '~/helpers/accountHelpers';
    defineProps<{
        groupList: object[]
    }>();
    const emit = defineEmits<{ 
        (e: 'add-confirm', item: Accounts.CreateAccountDTO): void 
    }>();
    const dialog = defineModel<boolean>(
        'dialog'
    );

    const item = ref<Accounts.CreateAccountDTO>(
        createDefaultAccountDTO()
    )
    const visiblePassword = ref(false)
    const formIsValid = ref(false)
    const visiblePasswordConfirm = ref(false)
    const { t } = useI18n();
    const rules = [
        (v: string) => !!v || t('components.widgets.accounts.rules.default')
    ];
    const passwordRules = [
        (v: string) => !!v || t('components.widgets.accounts.rules.default'),
        (v: string) => v.length >= 6 || t('components.widgets.accounts.rules.password'),
    ]
    const passwordConfirmRules = computed(() => [
        (v: string) => !!v || t('components.widgets.accounts.rules.default'),
        (v: string) => v === item.value.password || t('components.widgets.accounts.rules.passwordConfirm'),
    ])

    const confirm = () => {
        emit('add-confirm', item.value)
        dialog.value = false
        item.value = createDefaultAccountDTO()
    }

    const onClose = () => {
        dialog.value = false
        item.value = createDefaultAccountDTO()
    }
</script>