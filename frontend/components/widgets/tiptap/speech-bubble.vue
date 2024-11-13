<template>
    <v-card class="pa-3 mb-2 speech-bubble" outlined>
        <v-row align="center">
            <v-avatar class="mr-2">{{ speakerInitial }}</v-avatar>
            <v-col>
                <span class="speaker">{{ speaker }}:</span>
                <div class="bubble-content">
                    <slot></slot>
                </div>
            </v-col>
        </v-row>
    </v-card>
</template>

<script lang="ts">
export default defineComponent({
    props: {
        speaker: {
            type: String as PropType<string>,
            required: true,
            default: "Speaker"
        }
    },
    setup(props) {
        const speakerInitial = computed(() => props.speaker[0]?.toUpperCase() || "?");
        return { speakerInitial };
    }
});
</script>

<style scoped>
.speech-bubble {
    max-width: 400px;
}

.speaker {
    font-weight: bold;
    margin-right: 5px;
}

.bubble-content {
    display: inline;
}
</style>
