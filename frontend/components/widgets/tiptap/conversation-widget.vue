<template>
    <node-view-wrapper>
        <div>123</div>
    </node-view-wrapper>
</template>
<script setup lang="ts">
import { nodeViewProps, NodeViewWrapper } from "@tiptap/vue-3";
const props = defineProps(nodeViewProps);

onMounted(() => {
    console.log(props);
});
</script>
