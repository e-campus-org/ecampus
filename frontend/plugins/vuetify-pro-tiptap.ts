import {
    VuetifyTiptap,
    VuetifyViewer,
    createVuetifyProTipTap,
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
    History
} from "vuetify-pro-tiptap";
import { Conversation, SpeechBubble } from "@/extensions";
import "vuetify-pro-tiptap/style.css";

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
                async upload(file: File) {
                    return Promise.resolve(
                        await ((file: File) =>
                            new Promise((resolve, reject) => {
                                const reader = new FileReader();
                                reader.readAsDataURL(file);
                                reader.onload = () => resolve(reader.result as string);
                                reader.onerror = reject;
                            }))(file)
                    );
                }
            }),
            Video,
            Table,
            Blockquote,
            HorizontalRule,
            CodeBlock.configure({ divider: true }),
            History.configure({ divider: true }),
            Conversation,
            SpeechBubble
        ]
    });

    nuxtApp.vueApp.use(vuetifyProTipTap);
});
