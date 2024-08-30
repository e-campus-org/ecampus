<template>
    <client-only>
        <TiptapEditorContent :editor="editor" />
    </client-only>
</template>
<script setup lang="ts">
import type { Content } from "@tiptap/core";

const props = defineProps<{
    content: Content;
}>();

const lowlight = TiptapcreateLowlight(Tiptapall);

const editor = useEditor({
    content: props.content,
    extensions: [
        TiptapStarterKit.configure({
            codeBlock: false
        }),
        TiptapCodeBlockLowlight.configure({ lowlight })
    ],
    editable: false
});

watch([() => props.content, editor], ([newVal, _]) => {
    if (editor) {
        editor.value?.commands.setContent(newVal);
    }
});

onBeforeUnmount(() => {
    unref(editor).destroy();
});
</script>
