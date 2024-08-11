<template>
    <v-container fluid class="d-flex align-center justify-center h-screen">
        <v-sheet class="mx-auto py-4 px-3" width="300" color="background">
            <v-form ref="form" class="d-flex flex-column align-center ga-2" @submit.prevent="submit">
                <v-icon icon="mdi-account-circle" style="font-size: 96px" />
                <v-text-field
                    v-model="email.value.value"
                    class="w-100"
                    clearable
                    :error-messages="email.errorMessage.value"
                    :label="$t('pages.auth.email')"
                    :loading="loading"
                    :disabled="loading"
                    required
                />
                <v-text-field
                    v-model="password.value.value"
                    class="w-100"
                    type="password"
                    clearable
                    :error-messages="password.errorMessage.value"
                    :label="$t('pages.auth.password')"
                    :loading="loading"
                    :disabled="loading"
                    required
                />

                <v-btn class="mt-4" block type="submit" :loading="loading"> {{ $t("pages.auth.signIn") }} </v-btn>
            </v-form>
        </v-sheet>
    </v-container>
</template>
<script setup lang="ts">
import { useField, useForm } from "vee-validate";
import { FetchError } from "ofetch";

const { isFresh } = useJwt();

definePageMeta({
    layout: false
});

const { t } = useI18n();

const { handleSubmit } = useForm({
    validationSchema: {
        email(v: string) {
            if (!v) {
                return t("pages.auth.emailIsRequired");
            }
            if (!/^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$/.test(v)) {
                return t("pages.auth.invalidEmail");
            }
            return true;
        },
        password(v: string) {
            if (!v) {
                return t("pages.auth.passwordIsRequired");
            }
            return true;
        }
    }
});

const email = useField("email");
const password = useField("password");
const localLoading = ref(false);
// useLoadingIndicator doesn't works correctly
const nuxtLoading = useNuxtLoading();

const loading = computed(() => localLoading.value || nuxtLoading.value);

const accessToken = useCookie("access_token", {
    watch: true,
    secure: true,
    sameSite: true
});

const submit = handleSubmit(async values => {
    try {
        localLoading.value = true;
        const result = await useFetch<{ access_token: string }>("/auth/signin", {
            body: values,
            method: "POST"
        });
        accessToken.value = result.access_token;
    } catch (e: unknown) {
        if (e instanceof FetchError && e.status === 401) {
            useEvent("notify:error", t("errors.unauthorized"));
        } else {
            useEvent("notify:error", t("errors.unknown"));
        }
    } finally {
        localLoading.value = false;
    }
});

watch(
    isFresh,
    newValue => {
        if (newValue) {
            navigateTo({ name: "dashboard" });
        }
    },
    { immediate: true }
);
</script>
