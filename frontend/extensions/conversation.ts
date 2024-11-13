import { Node, mergeAttributes } from "@tiptap/core";
import { ActionButton } from "vuetify-pro-tiptap";
import { VueNodeViewRenderer } from "@tiptap/vue-3";
import { ConversationWidget } from "@/components/widgets/tiptap";

export default Node.create({
    name: "conversation",

    group: "block",

    content: "speechBubble+",

    parseHTML() {
        return [
            {
                tag: "div.conversation"
            }
        ];
    },

    renderHTML({ HTMLAttributes }) {
        return ["div", mergeAttributes(HTMLAttributes, { class: "conversation" }), 0];
    },

    addOptions() {
        return {
            button: ({ editor, t }) => ({
                component: ActionButton,
                componentProps: {
                    action: () => {
                        editor
                            .chain()
                            .focus()
                            .insertContent({
                                type: "conversation",
                                content: [
                                    {
                                        type: "speechBubble",
                                        attrs: { speaker: "Alice" },
                                        content: [
                                            {
                                                type: "text",
                                                text: "Привет! Как дела?"
                                            }
                                        ]
                                    },
                                    {
                                        type: "speechBubble",
                                        attrs: { speaker: "Bob" },
                                        content: [
                                            {
                                                type: "text",
                                                text: "Все отлично! Как ты?"
                                            }
                                        ]
                                    }
                                ]
                            })
                            .run();
                    },
                    isActive: () => editor.isActive("blockquote") || false,
                    disabled: false, //!editor.can().toggleBlockquote(),
                    icon: "chat",
                    tooltip: t("editor.blockquote.tooltip")
                }
            })
        };
    },

    addNodeView() {
        return VueNodeViewRenderer(ConversationWidget);
    }
});
