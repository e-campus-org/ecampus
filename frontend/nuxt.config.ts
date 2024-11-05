// https://nuxt.com/docs/api/configuration/nuxt-config

export default defineNuxtConfig({
    compatibilityDate: "2024-04-03",
    devtools: { enabled: false },
    spaLoadingTemplate: "./components/shared/nuxt-loading.vue",
    routeRules: {
        "/": { prerender: true },
        "/dashboard": { redirect: "/dashboard/my" },
        "/admin": { redirect: "/admin/accounts" }
    },
    modules: [
        "@nuxt/eslint",
        "@nuxtjs/i18n",
        "nuxt-lodash",
        "dayjs-nuxt",
        "@vee-validate/nuxt",
        "nuxt-viewport",
        "nuxt-monaco-editor",
        "@pinia/nuxt",
        "vuetify-nuxt-module",
        "@vueuse/nuxt",
        "nuxt-tiptap-editor"
    ],
    tiptap: {
        prefix: "Tiptap",
        lowlight: {
            theme: "github-dark"
        }
    },
    i18n: {
        vueI18n: "./i18n.ts"
    },
    vuetify: {
        vuetifyOptions: {
            theme: {
                defaultTheme: "dark"
            }
        },
        moduleOptions: {
            ssrClientHints: {
                viewportSize: true,
                prefersColorScheme: true
            }
        }
    },
    monacoEditor: {
        locale: "en",
        componentName: {
            codeEditor: "MonacoEditor",
            diffEditor: "MonacoDiffEditor"
        }
    },
    runtimeConfig: {
        public: {
            apiUrl: process.env.NUXT_PUBLIC_API_URL
        }
    },
    app: {
        head: {
            htmlAttrs: {
                translate: "no"
            },
            meta: [
                {
                    name: "google",
                    content: "notranslate"
                }
            ],
            link: [
                {
                    rel: "stylesheet",
                    id: "highlight-js"
                }
            ]
        }
    }
});