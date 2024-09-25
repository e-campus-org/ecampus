<template>
    <div class="pa-4 text-center">
      <v-dialog
        v-model="dialog"
        max-width="600"
      >
  
        <v-card
          prepend-icon="mdi-account"
          title="Профиль"
        >
          <v-form v-model="formIsValid">
            <v-card-text>
              <v-row dense>
                  <v-col>
                  <v-text-field
                      v-model="localItem.title"
                      label="Title*"
                      :rules="rules"
                  ></v-text-field>
                  </v-col>
              </v-row>
              <v-row dense>
                  <v-col>
                  <v-text-field
                      v-model="localItem.code"
                      label="Speciality code*"
                      :rules="rules"
                  ></v-text-field>
                  </v-col>
              </v-row>
              <v-row dense>
                  <v-col>
                  <v-text-field
                      v-model="localItem.description"
                      label="Description*"
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
              text="Отмена"
              variant="plain"
              @click="dialog = false"
            ></v-btn>
  
            <v-btn
              color="primary"
              text="Изменить"
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

    const dialog = defineModel<boolean>('dialog')
    const formIsValid = ref(false)
    const rules = [value => !!value || 'Обязательное поле']

    const props = defineProps<{
        item: Specialities.ReadSpecialityDTO
    }>()

    const emit = defineEmits<{
        (e: 'edit-confirm', item: object): void
    }>()

    const localItem = reactive({ 
        title: props.item.title,
        code: props.item.code,
        description: props.item.description
     });

    watch(() => props.item, (newItem) => {
        localItem.title = newItem.title;
        localItem.code = newItem.code;
        localItem.description = newItem.description;
    });

    const onEdit = () => {
        emit('edit-confirm', localItem)
    }


</script>
