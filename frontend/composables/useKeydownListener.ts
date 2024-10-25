import { onMounted, onBeforeUnmount } from "vue";

export function useKeydownListener(handler: (event: KeyboardEvent) => void) {
    function addKeydownListener() {
        window.addEventListener("keydown", handler);
    }

    function removeKeydownListener() {
        window.removeEventListener("keydown", handler);
    }

    onMounted(() => {
        addKeydownListener();
    });

    onBeforeUnmount(() => {
        removeKeydownListener();
    });

    return { addKeydownListener, removeKeydownListener };
}
