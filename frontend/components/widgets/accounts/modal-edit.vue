<template>
  <div class="pa-4 text-center">
    <v-dialog
      v-model="dialog"
      max-width="600"
    >

      <v-card
        prepend-icon="mdi-account"
        :title="$t('components.widgets.accounts.edit.editTitle')"
      >

        <v-form v-model="formIsValid">
          <v-card-text>
            <v-row dense>
                  <v-col>
                  <v-text-field
                      v-model="localItem.first_name"
                      :label="$t('components.widgets.accounts.edit.firstName')"
                      :rules="rules"
                  ></v-text-field>
                  </v-col>
                  <v-col>
                  <v-text-field
                      v-model="localItem.last_name"
                      :label="$t('components.widgets.accounts.edit.lastName')"
                      :rules="rules"
                  ></v-text-field>
                  </v-col>
              </v-row>
              <v-row dense>
                  <v-col>
                      <v-select 
                          v-model="localItem.group_id"
                          :items="groupList"
                          item-value="id"
						              item-title="title"
                          :label="$t('components.widgets.accounts.edit.group')"
                      />
                  </v-col>
                  <v-col>
                      <v-select 
                          v-model="localItem.roles"
                          :rules="rules"
                          :items="['student', 'admin', 'teacher']"
                          :label="$t('components.widgets.accounts.edit.roles')"
                          multiple
                      />
                  </v-col>
              </v-row>
              <v-row dense>
                  <v-col>
                  <v-text-field
                      v-model="localItem.email"
                      :label="$t('components.widgets.accounts.edit.email')"
                      :rules="rules"
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
            :rules="rules"
            @click="dialog = false"
          ></v-btn>

          <v-btn
            color="primary"
            :text="$t('components.widgets.accounts.edit.save')"
            variant="tonal"
            :disabled="!formIsValid"
            @click="onEdit"
          ></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup lang="ts">
    import { updateDefaultAccountDTO } from '~/helpers/accountHelpers';

    const props = defineProps<{
      item: Accounts.ReadAccountDTO,
      groupList: object[]
    }>();
    const emit = defineEmits<{
      (e: 'edit-confirm', item: Accounts.UpdateAccountDTO): void
    }>();
    const dialog = defineModel<boolean>(
      'dialog'
    );

    const { t } = useI18n();
    const rules = [
      (v: string) => !!v || t('components.widgets.accounts.rules.default')
    ];
    const formIsValid = ref(false)

    const localItem = ref<Accounts.UpdateAccountDTO>(
      updateDefaultAccountDTO()
    )

    watch(
      () => props.item, 
      (newItem) => {
        localItem.value = updateDefaultAccountDTO(newItem)
      }, 
      { immediate: true }
    );
    
    const onEdit = () => {
      emit('edit-confirm', localItem.value)
    }

</script>