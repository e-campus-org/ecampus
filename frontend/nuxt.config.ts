// https://nuxt.com/docs/api/configuration/nuxt-config
import { md3 } from "vuetify/blueprints";

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
        "@vueuse/nuxt"
    ],
    i18n: {
        vueI18n: "./i18n.ts"
    },
    vuetify: {
        vuetifyOptions: {
            blueprint: md3,
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
            apiUrl: ""
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
