import App from "./App.vue";
import { createApp } from "vue";
import { createVuetify } from "vuetify";
import { createPinia } from "pinia";
import router from "@/router";
import { md3 } from "vuetify/blueprints";

import "@mdi/font/css/materialdesignicons.css";

const vuetify = createVuetify({
  theme: {
    defaultTheme: "dark",
  },
  blueprint: md3,
});

const pinia = createPinia();

const app = createApp(App);

app.use(vuetify).use(router).use(pinia);

app.mount("#app");
