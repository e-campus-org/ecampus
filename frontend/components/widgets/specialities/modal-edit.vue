<template>
    <div class="pa-4 text-center">
      <v-dialog
        v-model="dialog"
        max-width="600"
      >
  
        <v-card
          prepend-icon="mdi-account"
          :title="$t('components.widgets.specialities.edit.editTitle')"
        >
          <v-form v-model="formIsValid">
            <v-card-text>
              <v-row dense>
                  <v-col>
                  <v-text-field
                      v-model="localItem.title"
                      :label="$t('components.widgets.specialities.edit.title')"
                      :rules="rules"
                  ></v-text-field>
                  </v-col>
              </v-row>
              <v-row dense>
                  <v-col>
                  <v-text-field
                      v-model="localItem.code"
                      :label="$t('components.widgets.specialities.edit.code')"
                      :rules="rules"
                  ></v-text-field>
                  </v-col>
              </v-row>
              <v-row dense>
                  <v-col>
                  <v-text-field
                      v-model="localItem.description"
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
              @click="dialog = false"
            ></v-btn>
  
            <v-btn
              color="primary"
              :text="$t('components.widgets.specialities.edit.save')"
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
    import { updateDefaultSpecialityDTO } from '~/helpers/specialityHelpers';

    const props = defineProps<{
        item: Specialities.ReadSpecialityDTO
    }>();
    const emit = defineEmits<{
        (e: 'edit-confirm', item: Specialities.UpdateSpecialityDTO): void
    }>();
    const dialog = defineModel<boolean>('dialog');

    const { t } = useI18n();
    const formIsValid = ref(false)
    const rules = [
      (v: string) => !!v || t('components.widgets.accounts.rules.default')
    ];
    const localItem = ref<Specialities.UpdateSpecialityDTO>(
      updateDefaultSpecialityDTO()
    );

    watch(
      () => props.item, 
      (newItem) => {
        localItem.value = updateDefaultSpecialityDTO(newItem)
      }, 
      { immediate: true }
    );

    const onEdit = () => {
        emit('edit-confirm', localItem.value)
    }


</script>
