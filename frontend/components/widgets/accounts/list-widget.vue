<template>
    <div class="table-wrapper">
        <v-data-table
            :headers="headers"
            :items="sortedItems"
            :loading="loading"
            :items-per-page="props.pageSize"
            :mobile-breakpoint="0"
            @click:row="(event, item) => openEditModal(item.item)"
        >
            <template #item.actions="{ item }">
                <v-btn @click.stop="openDeleteModal(item)" icon elevation="0">
                    <v-icon>mdi-delete</v-icon>
                </v-btn>
            </template>

            <template #bottom>
                <div class="pagination-wrapper">
                    <v-pagination
                        v-model="currentPage"
                        :length="props.data?.pagination?.pages || 0"
                        class="pagination"
                    />
                    <v-btn icon large @click="openAddModal" class="add-button">
                        <v-icon large>mdi-plus</v-icon>
                    </v-btn>
                </div>
            </template>
        </v-data-table>

        <edit-modal
            :headers="editModalHeaders"
            :name="editModalNames"
            :err="editModalErrors"
            v-model="isEditModal"
            :item="selectedItem"
            @save="addEdit"
        />
        <delete-modal v-model="isDeleteModal" :item="selectedItem" @delete="deleteItem" :name="deleteModalNames" />
    </div>
</template>

<script setup lang="ts">
import EditModal from "./edit-modal.vue";
import DeleteModal from "./delete-modul.vue";
import { ref, watch, computed } from "vue";

const props = defineProps<{
    data: Shared.ListData<Accounts.ReadAccountDTO> | null;
    loading: boolean;
    page: number;
    pageSize: number;
}>();

const emit = defineEmits<{
    (e: "page-changed", page: number): void;
    (e: "save-item", item: Accounts.ReadAccountDTO): void;
    (e: "add-item", item: Accounts.ReadAccountDTO): void;
    (e: "delete-item", item: Accounts.ReadAccountDTO): void;
}>();

const isEditModal = ref(false);
const isDeleteModal = ref(false);
const selectedItem = ref({});
const isNewItem = ref(false);

function openEditModal(item: any) {
    isNewItem.value = false;
    selectedItem.value = { ...item };
    isEditModal.value = true;
}

function openDeleteModal(item: any) {
    isNewItem.value = false;
    selectedItem.value = { ...item };
    isDeleteModal.value = true;
}

function openAddModal() {
    isNewItem.value = true;
    selectedItem.value = {
        id: null,
        email: "",
        firstName: "",
        lastName: "",
        group: "",
        roles: []
    };
    isEditModal.value = true;
}

function addEdit(editedItem: any) {
    if (isNewItem.value) {
        emit("add-item", editedItem);
    } else {
        emit("save-item", editedItem);
    }
    closeModal();
    isNewItem.value = false;
}

function deleteItem(editedItem: any) {
    const index = props.data?.list?.findIndex(i => i.id === editedItem.id);
    if (index !== -1) {
        props.data!.list!.splice(index, 1);
    }
    emit("delete-item", editedItem);
}

function closeModal() {
    isEditModal.value = false;
    isDeleteModal.value = false;
    selectedItem.value = {};
}

watch(isEditModal, newVal => {
    if (!newVal) {
        closeModal();
    }
});
watch(isDeleteModal, newVal => {
    if (!newVal) {
        closeModal();
    }
});

const { t } = useI18n();
const dayjs = useDayjs();

const editModalHeaders = computed(() => ({
    email: t("components.widgets.accounts.headers.email"),
    firstName: t("components.widgets.accounts.headers.firstName"),
    group: t("components.widgets.accounts.headers.group"),
    lastName: t("components.widgets.accounts.headers.lastName"),
    roles: t("components.widgets.accounts.headers.roles"),
    password: t("components.widgets.accounts.modal.password"),
    passwordConfirmation: t("components.widgets.accounts.modal.passwordConfirmation")
}));
const editModalErrors = computed(() => ({
    email: t("components.widgets.accounts.error.email"),
    firstName: t("components.widgets.accounts.error.firstName"),
    group: t("components.widgets.accounts.error.group"),
    lastName: t("components.widgets.accounts.error.lastName"),
    rolesRequired: t("components.widgets.accounts.error.rolesRequired"),
    rolesSame: t("components.widgets.accounts.error.rolesSame"),
    password: t("components.widgets.accounts.error.password"),
    passwordConfirmation: t("components.widgets.accounts.error.passwordConfirmation")
}));
const editModalNames = computed(() => ({
    title: isNewItem.value
        ? t("components.widgets.accounts.modal.create_title")
        : t("components.widgets.accounts.modal.edit_title"),
    cancel: t("components.widgets.accounts.modal.cancel"),
    save: isNewItem.value ? t("components.widgets.accounts.action.add") : t("components.widgets.accounts.modal.save")
}));

const deleteModalNames = computed(() => ({
    title: t("components.widgets.accounts.modal.delete_title"),
    text: t("components.widgets.accounts.modal.delete_text"),
    cancel: t("components.widgets.accounts.modal.cancel"),
    delete: t("components.widgets.accounts.modal.delete")
}));

const currentPage = computed({
    get: () => props.page,
    set: page => emit("page-changed", page)
});

const headers = computed(() => [
    {
        title: t("components.widgets.accounts.headers.id"),
        align: "start",
        sortable: false,
        key: "id"
    },
    {
        title: t("components.widgets.accounts.headers.email"),
        align: "start",
        sortable: false,
        key: "email"
    },
    {
        title: t("components.widgets.accounts.headers.firstName"),
        align: "start",
        sortable: false,
        key: "first_name"
    },
    {
        title: t("components.widgets.accounts.headers.lastName"),
        align: "start",
        sortable: false,
        key: "last_name"
    },
    {
        title: t("components.widgets.accounts.headers.group"),
        align: "start",
        sortable: false,
        key: "group_id"
    },
    {
        title: t("components.widgets.accounts.headers.roles"),
        align: "start",
        sortable: false,
        key: "roles",
        value: (item: Accounts.ReadAccountDTO) => item.roles?.join(", ")
    },
    {
        title: t("components.widgets.accounts.headers.insertedAt"),
        align: "start",
        sortable: false,
        key: "inserted_at",
        value: (item: Accounts.ReadAccountDTO) => dayjs(item.inserted_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.accounts.headers.updatedAt"),
        align: "start",
        sortable: false,
        key: "updated_at",
        value: (item: Accounts.ReadAccountDTO) => dayjs(item.updated_at).format("DD.MM.YYYY HH:mm:ss")
    },
    {
        title: t("components.widgets.accounts.action.delete"),
        align: "center",
        sortable: false,
        key: "actions"
    }
]);

const sortedItems = computed(() => {
    if (!props.data?.list) return [];

    const admin = t("components.widgets.accounts.roles.admin");
    const teacher = t("components.widgets.accounts.roles.teacher");
    const student = t("components.widgets.accounts.roles.student");

    return [...props.data.list]
        .sort((a, b) => a.id - b.id)
        .map(item => {
            const rolesMap = {
                admin: admin,
                student: student,
                teacher: teacher
            };

            item.roles = item.roles.map(role => rolesMap[role] || role);

            return item;
        });
});
</script>

<style scoped>
.table-wrapper {
    display: flex;
    flex-direction: column;
    height: 100%;
}

.pagination-wrapper {
    display: grid;
    grid-template-columns: 1fr auto;
    align-items: center;
    padding: 16px;
}

.pagination {
    min-width: 240px;
    justify-self: center;
}

.add-button {
    margin-left: 16px;
}
</style>
