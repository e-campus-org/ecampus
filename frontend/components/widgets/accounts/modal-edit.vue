<template>
  <div class="pa-4 text-center">
    <v-dialog
      v-model="dialog"
      max-width="600"
    >

      <v-card
        prepend-icon="mdi-account"
        title="В процессе доработки"
        disabled
        color="red"
      >
        <v-card-text>
          <v-row dense>
                <v-col>
                <v-text-field
                    v-model="localItem.first_name"
                    label="First name*"
                    required
                ></v-text-field>
                </v-col>
                <v-col>
                <v-text-field
                    v-model="localItem.last_name"
                    label="Last name*"
                    required
                ></v-text-field>
                </v-col>
            </v-row>
            <v-row dense>
                <v-col>
                    <v-select 
                        v-model="localItem.group_id"
                        :items="idList"
                        label="Group*"
                        required
                    />
                </v-col>
                <v-col>
                    <v-select 
                        v-model="localItem.roles"
                        :items="['student', 'admin']"
                        label="Role*"
                        required
                        multiple
                    />
                </v-col>
            </v-row>
            <v-row dense>
                <v-col>
                <v-text-field
                    v-model="localItem.email"
                    label="Email*"
                    required
                ></v-text-field>
                </v-col>
            </v-row>
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>
          <v-spacer></v-spacer>

          <v-btn
            text="Отмена"
            variant="plain"
            @click="dialog = false"
          ></v-btn>

          <v-btn
            color="primary"
            text="Изменить"
            variant="tonal"
            @click="onEdit"
          ></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup lang="ts">
  const dialog = defineModel<boolean>('dialog')

  const props = defineProps<{
    item: Accounts.ReadAccountDTO,
    idList: number[]
  }>()

  const emit = defineEmits<{
    (e: 'edit-confirm', item: object): void
  }>()

  const localItem = reactive({ 
      first_name: props.item.first_name,
      last_name: props.item.last_name,
      group_id: props.item.group_id,
      roles: props.item.roles,
      email: props.item.email,
  });

  watch(() => props.item, (newItem) => {
    localItem.first_name = newItem.first_name,
    localItem.last_name = newItem.last_name,
    localItem.group_id = newItem.group_id,
    localItem.roles = newItem.roles,
    localItem.email = newItem.email
});
  const onEdit = () => {
    emit('edit-confirm', localItem)
  }

</script>

<style>

</style>