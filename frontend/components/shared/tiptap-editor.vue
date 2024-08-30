<template>
    <client-only>
        <div v-if="editor" class="d-flex flex-row justify-start align-center flex-wrap ga-2">
            <v-btn
                icon="mdi-format-bold"
                size="small"
                :disabled="!editor.can().chain().focus().toggleBold().run()"
                :variant="!editor.isActive('bold') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleBold().run()"
            />
            <v-btn
                icon="mdi-format-italic"
                size="small"
                :disabled="!editor.can().chain().focus().toggleItalic().run()"
                :variant="!editor.isActive('italic') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleItalic().run()"
            />
            <v-btn
                icon="mdi-format-strikethrough"
                size="small"
                :disabled="!editor.can().chain().focus().toggleStrike().run()"
                :variant="!editor.isActive('strike') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleStrike().run()"
            />
            <v-btn
                icon="mdi-code-tags"
                size="small"
                :disabled="!editor.can().chain().focus().toggleCode().run()"
                :variant="!editor.isActive('code') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleCode().run()"
            />
            <v-btn
                icon="mdi-format-paragraph"
                size="small"
                :variant="!editor.isActive('paragraph') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().setParagraph().run()"
            />
            <v-btn
                icon="mdi-format-clear"
                size="small"
                variant="text"
                @click="editor.chain().focus().unsetAllMarks().run()"
            />
            <v-btn
                icon="mdi-format-header-1"
                size="small"
                :variant="!editor.isActive('heading', { level: 1 }) || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleHeading({ level: 1 }).run()"
            />
            <v-btn
                icon="mdi-format-header-2"
                size="small"
                :variant="!editor.isActive('heading', { level: 2 }) || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleHeading({ level: 2 }).run()"
            />
            <v-btn
                icon="mdi-format-header-3"
                size="small"
                :variant="!editor.isActive('heading', { level: 3 }) || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleHeading({ level: 3 }).run()"
            />
            <v-btn
                icon="mdi-format-header-4"
                size="small"
                :variant="!editor.isActive('heading', { level: 4 }) || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleHeading({ level: 4 }).run()"
            />
            <v-btn
                icon="mdi-format-header-5"
                size="small"
                :variant="!editor.isActive('heading', { level: 5 }) || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleHeading({ level: 5 }).run()"
            />
            <v-btn
                icon="mdi-format-header-6"
                size="small"
                :variant="!editor.isActive('heading', { level: 6 }) || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleHeading({ level: 6 }).run()"
            />
            <v-btn
                icon="mdi-format-list-bulleted"
                size="small"
                :variant="!editor.isActive('bulletList') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleBulletList().run()"
            />
            <v-btn
                icon="mdi-format-list-numbered"
                size="small"
                :variant="!editor.isActive('orderedList') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleOrderedList().run()"
            />
            <v-btn
                icon="mdi-code-braces"
                size="small"
                :variant="!editor.isActive('codeBlock') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleCodeBlock().run()"
            />
            <v-btn
                icon="mdi-comment-quote"
                size="small"
                :variant="!editor.isActive('blockquote') || !isFocused ? 'text' : 'tonal'"
                @click="editor.chain().focus().toggleBlockquote().run()"
            />
            <!-- 


        <button @click="editor.chain().focus().setHorizontalRule().run()">
          horizontal rule
        </button>
        <button @click="editor.chain().focus().setHardBreak().run()">
          hard break
        </button>
        <button
          @click="editor.chain().focus().undo().run()"
          :disabled="!editor.can().chain().focus().undo().run()"
        >
          undo
        </button>
        <button
          @click="editor.chain().focus().redo().run()"
          :disabled="!editor.can().chain().focus().redo().run()"
        >
          redo
        </button> -->
        </div>

        <TiptapEditorContent :editor="editor" />
    </client-only>
</template>

<script setup lang="ts">
import type { Content } from "@tiptap/core";

const props = defineProps<{
    modelValue: string;
}>();

const emit = defineEmits<{
    (e: "update:modelValue", content: Content): void;
}>();

const lowlight = TiptapcreateLowlight(Tiptapall);

const editor = useEditor({
    content: props.modelValue,
    extensions: [
        TiptapStarterKit.configure({
            codeBlock: false
        }),
        TiptapCodeBlockLowlight.configure({ lowlight })
    ],
    onFocus: () => (isFocused.value = true),
    onBlur: () => (isFocused.value = false),
    onUpdate: ({ editor }) => {
        emit("update:modelValue", editor.getJSON());
    }
});

watch([() => props.modelValue, editor], ([newVal, _]) => {
    if (editor) {
        editor.value?.commands.setContent(newVal);
    }
});

const isFocused = ref(false);

onBeforeUnmount(() => {
    unref(editor).destroy();
});
</script>
<style>
pre {
    background: #0d0d0d;
    color: #fff;
    font-family: "JetBrainsMono", monospace;
    padding: 0.75rem 1rem;
    border-radius: 0.5rem;

    code {
        color: inherit;
        padding: 0;
        background: none;
        font-size: 0.8rem;
    }

    .hljs-comment,
    .hljs-quote {
        color: #616161;
    }

    .hljs-variable,
    .hljs-template-variable,
    .hljs-attribute,
    .hljs-tag,
    .hljs-name,
    .hljs-regexp,
    .hljs-link,
    .hljs-name,
    .hljs-selector-id,
    .hljs-selector-class {
        color: #f98181;
    }

    .hljs-number,
    .hljs-meta,
    .hljs-built_in,
    .hljs-builtin-name,
    .hljs-literal,
    .hljs-type,
    .hljs-params {
        color: #fbbc88;
    }

    .hljs-string,
    .hljs-symbol,
    .hljs-bullet {
        color: #b9f18d;
    }

    .hljs-title,
    .hljs-section {
        color: #faf594;
    }

    .hljs-keyword,
    .hljs-selector-tag {
        color: #70cff8;
    }

    .hljs-emphasis {
        font-style: italic;
    }

    .hljs-strong {
        font-weight: 700;
    }
}
</style>
