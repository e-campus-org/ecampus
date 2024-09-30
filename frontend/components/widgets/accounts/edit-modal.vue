<template>
    <v-dialog v-model="dialog" max-width="500px">
        <v-card>
            <v-card-title class="headline">{{ name.title }}</v-card-title>
            <v-card-text>
                <v-form ref="editForm" @keydown.enter.prevent="submitOnEnter">
                    <v-text-field
                        v-model="createItem.email"
                        :label="headers.email"
                        required
                        ref="emailInput"
                        :error-messages="emailErrorMessages"
                    />
                    <v-text-field
                        v-model="createItem.firstName"
                        :label="headers.firstName"
                        required
                        :error-messages="firstNameErrorMessages"
                    />
                    <v-text-field
                        v-model="createItem.lastName"
                        :label="headers.lastName"
                        required
                        :error-messages="lastNameErrorMessages"
                    />
                    <v-text-field
                        v-model="createItem.group"
                        :label="headers.group"
                        required
                        :error-messages="groupErrorMessages"
                    />
                    <v-text-field
                        v-if="!props.item.created_at"
                        v-model="createItem.password"
                        :label="headers.password"
                        required
                        :error-messages="passwordErrorMessages"
                    />
                    <v-text-field
                        v-if="!props.item.created_at"
                        v-model="createItem.passwordConfirmation"
                        :label="headers.passwordConfirmation"
                        required
                        :error-messages="passwordConfirmationErrorMessages"
                    />
                    <v-select
                        v-model="createItem.roles"
                        :items="selectItems"
                        :item-text="'text'"
                        :item-value="'value'"
                        multiple
                        persistent-hint
                        :hint="hint"
                        :label="selected"
                        :error-messages="rolesErrorMessages"
                    />
                </v-form>
            </v-card-text>
            <v-card-actions>
                <v-btn text @click="close">{{ name.cancel }}</v-btn>
                <v-btn text @click="save">{{ name.save }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch, computed, onMounted } from "vue";

const { t } = useI18n();

const selected = computed(() => t("components.widgets.accounts.modal.selected"));
const hint = computed(() => t("components.widgets.accounts.modal.hint"));

const selectItems = [
    t("components.widgets.accounts.roles.admin"),
    t("components.widgets.accounts.roles.teacher"),
    t("components.widgets.accounts.roles.student")
];

const correlate = {
    admin: t("components.widgets.accounts.roles.admin"),
    teacher: t("components.widgets.accounts.roles.teacher"),
    student: t("components.widgets.accounts.roles.student")
};

const props = defineProps({
    modelValue: Boolean,
    item: Object,
    headers: {
        type: Object,
        required: true
    },
    name: {
        type: Object,
        required: true
    },
    err: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(["update:modelValue", "save"]);

const dialog = ref(false);
const createItem = reactive({
    id: null,
    email: "",
    firstName: "",
    lastName: "",
    password: "",
    passwordConfirmation: "",
    group: "",
    roles: []
});

const emailErrorMessages = ref<string[]>([]);
const firstNameErrorMessages = ref<string[]>([]);
const lastNameErrorMessages = ref<string[]>([]);
const groupErrorMessages = ref<string[]>([]);
const passwordErrorMessages = ref<string[]>([]);
const passwordConfirmationErrorMessages = ref<string[]>([]);
const rolesErrorMessages = ref<string[]>([]);

const titleInput = ref<HTMLInputElement | null>(null);

watch(
    () => props.modelValue,
    newVal => {
        dialog.value = newVal;
        if (newVal && props.item) {
            createItem.id = props.item.id;
            createItem.email = props.item.email;
            createItem.firstName = props.item.first_name;
            createItem.lastName = props.item.last_name;
            createItem.group = props.item.group_id;
            createItem.roles = props.item.roles || [];

            createItem.password = "";
            createItem.passwordConfirmation = "";
            setTimeout(() => {
                titleInput.value?.focus();
            }, 10);
        }
    }
);

watch(dialog, newVal => {
    emit("update:modelValue", newVal);
});

function close() {
    emit("update:modelValue", false);
}

function validateInputs() {
    emailErrorMessages.value = [];
    firstNameErrorMessages.value = [];
    lastNameErrorMessages.value = [];
    groupErrorMessages.value = [];
    rolesErrorMessages.value = [];
    passwordErrorMessages.value = [];
    passwordConfirmationErrorMessages.value = [];

    let isValid = true;

    if (!createItem.email) {
        emailErrorMessages.value.push(props.err.email || "Email is required.");
        isValid = false;
    }
    if (!createItem.firstName) {
        firstNameErrorMessages.value.push(props.err.firstName || "First name is required.");
        isValid = false;
    }
    if (!createItem.lastName) {
        lastNameErrorMessages.value.push(props.err.lastName || "Last name is required.");
        isValid = false;
    }

    if (!createItem.roles.length) {
        rolesErrorMessages.value.push(props.err.rolesRequired || "Roles are required.");
        isValid = false;
    }
    if (
        (createItem.roles.includes("admin") || createItem.roles.includes("teacher")) &&
        createItem.roles.includes("student")
    ) {
        rolesErrorMessages.value.push(
            props.err.rolesSame ||
                "You cannot have the roles 'admin' and 'student' or 'teacher' and 'student' at the same time"
        );
        isValid = false;
    }
    if (!props.item.created_at) {
        if (!createItem.password) {
            passwordErrorMessages.value.push(props.err.password || "Password is required.");
            isValid = false;
        }
        if (!createItem.passwordConfirmation) {
            passwordConfirmationErrorMessages.value.push(
                props.err.passwordConfirmation || "Password confirmation is required."
            );
            isValid = false;
        }
        if (createItem.password !== createItem.passwordConfirmation) {
            passwordErrorMessages.value.push("Passwords do not match.");
            isValid = false;
        }
    }

    return isValid;
}

function save() {
    if (validateInputs()) {
        const itemToSave = { ...createItem };

        itemToSave.roles = createItem.roles.map(role => {
            const matchedRole = Object.keys(correlate).find(key => correlate[key] === role);
            return matchedRole || role;
        });

        if (props.item.created_at) {
            delete itemToSave.password;
            delete itemToSave.passwordConfirmation;
        }

        emit("save", itemToSave);
        close();
    }
}

function submitOnEnter() {
    save();
}

onMounted(() => {
    if (dialog.value) {
        setTimeout(() => {
            titleInput.value?.focus();
        }, 10);
    }
});
</script>
