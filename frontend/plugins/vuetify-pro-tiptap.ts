import { VuetifyTiptap, VuetifyViewer, createVuetifyProTipTap } from "vuetify-pro-tiptap";
import {
    BaseKit,
    Bold,
    Italic,
    Underline,
    Strike,
    Color,
    Highlight,
    Heading,
    TextAlign,
    FontFamily,
    FontSize,
    SubAndSuperScript,
    BulletList,
    OrderedList,
    TaskList,
    Indent,
    Link,
    Image,
    Video,
    Table,
    Blockquote,
    HorizontalRule,
    Code,
    CodeBlock,
    Clear,
    Fullscreen,
    History
} from "vuetify-pro-tiptap";
import "vuetify-pro-tiptap/style.css";
import { TiptapSelectImage } from "@/components/shared";

export default defineNuxtPlugin(nuxtApp => {
    const vuetifyProTipTap = createVuetifyProTipTap({
        lang: "en",
        components: {
            VuetifyTiptap,
            VuetifyViewer
        },
        extensions: [
            BaseKit.configure({
                placeholder: {
                    placeholder: "Enter some text..."
                }
            }),
            Bold,
            Italic,
            Underline,
            Strike,
            Code.configure({ divider: true }),
            Heading,
            TextAlign,
            FontFamily,
            FontSize,
            Color,
            Highlight.configure({ divider: true }),
            SubAndSuperScript.configure({ divider: true }),
            Clear.configure({ divider: true }),
            BulletList,
            OrderedList,
            TaskList,
            Indent.configure({ divider: true }),
            Link,
            Image.configure({
                imageTabs: [{ name: "SELECT", component: markRaw(TiptapSelectImage) }],
                // hiddenTabs: ['upload'],
                upload(file: File) {
                    const url = URL.createObjectURL(file);
                    console.log("mock upload api :>> ", url);
                    return Promise.resolve(url);
                }
            }),
            Video,
            Table,
            Blockquote,
            HorizontalRule,
            CodeBlock.configure({ divider: true }),
            History.configure({ divider: true }),
            Fullscreen
        ]
    });

    nuxtApp.vueApp.use(vuetifyProTipTap);
});
