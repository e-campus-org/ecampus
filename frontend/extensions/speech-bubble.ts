import { Node, mergeAttributes } from "@tiptap/core";
import { VueNodeViewRenderer } from "@tiptap/vue-3";
import { SpeechBubble } from "@/components/widgets/tiptap";

export default Node.create({
    name: "speechBubble",

    group: "block",

    content: "inline*",

    addAttributes() {
        return {
            speaker: {
                default: "Speaker"
            }
        };
    },

    parseHTML() {
        return [
            {
                tag: "div.speech-bubble"
            }
        ];
    },

    renderHTML({ HTMLAttributes }) {
        return [
            "div",
            mergeAttributes(HTMLAttributes, { class: "speech-bubble" }),
            ["span", { class: "speaker" }, HTMLAttributes.speaker + ": "],
            ["span", { class: "bubble-content" }, 0]
        ];
    },

    addNodeView() {
        return VueNodeViewRenderer(SpeechBubble);
    }
});
