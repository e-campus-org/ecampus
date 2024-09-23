<template>
    <div class="pa-4 text-center">
        <v-dialog
        v-model="dialog"
        max-width="600"
        >

        <v-card
            prepend-icon="mdi-account"
            title="User Profile"
        >
            <v-card-text>
            <v-row dense>
                <v-col>
                <v-text-field
                    v-model="item.title"
                    label="Title*"
                    required
                ></v-text-field>
                </v-col>
            </v-row>
            <v-row dense>
                <v-col>
                <v-text-field
                    v-model="item.code"
                    label="Speciality code*"
                    required
                ></v-text-field>
                </v-col>
            </v-row>
            <v-row dense>
                <v-col>
                <v-text-field
                    v-model="item.description"
                    label="Description*"
                    required
                ></v-text-field>
                </v-col>
            </v-row>
            </v-card-text>

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
                text="Создать"
                variant="tonal"
                @click="confirm"
            ></v-btn>
            </v-card-actions>
        </v-card>
        </v-dialog>
    </div>
</template>

<script setup lang="ts">
const dialog = defineModel<boolean>('dialog')
const emit = defineEmits<{ 
    (e: 'add-confirm', item: object): void 
}>()

const item = ref({})

const confirm = () => {
    emit('add-confirm', item.value)
    dialog.value = false
    item.value = {}
}


</script>