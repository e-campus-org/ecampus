// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    compatibilityDate: "2024-04-03",
    devtools: { enabled: true },
    modules: [
        "@nuxt/ui",
        "@nuxt/eslint",
        "@nuxtjs/i18n",
        "nuxt-lodash",
        "dayjs-nuxt",
        "@vee-validate/nuxt",
        "nuxt-viewport",
        "nuxt-monaco-editor",
        "@pinia/nuxt",
        "@pinia-plugin-persistedstate/nuxt"
    ],
    ui: {
        global: true,
        icons: ["heroicons"]
    },
    i18n: {
        vueI18n: "./i18n.ts"
    },
    viewport: {
        breakpoints: {
            xs: 576,
            sm: 640,
            md: 768,
            lg: 1024,
            xl: 1280,
            "2xl": 1536
        },
        defaultBreakpoints: {
            desktop: "lg",
            mobile: "xs",
            tablet: "md"
        },
        fallbackBreakpoint: "lg"
    },
    monacoEditor: {
        // These are default values:
        locale: "en",
        componentName: {
            codeEditor: "MonacoEditor",
            diffEditor: "MonacoDiffEditor"
        }
    },
    runtimeConfig: {
        public: {
            baseUrl: process.env.API_URL
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
