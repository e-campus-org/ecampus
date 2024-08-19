<template>
    <v-sheet>
        <v-calendar
            v-model="value"
            color="secondary"
            :weekdays="[1, 2, 3, 4, 5, 6, 0]"
            :types="['month', 'week', 'day']"
            :events="events"
            :text="$t('components.widgets.schedule.today')"
        >
            <template #event="{ event }">
                <v-chip color="primary" class="mb-1 cursor-pointer">
                    <span class="text-truncate">{{ event.title }}</span>
                    <v-tooltip activator="parent" location="top">
                        <div class="d-flex flex-column align-start justify-start">
                            <strong>{{ event.title }}</strong>
                            <span>{{ event.classroom }}</span>
                            <span
                                >{{ $dayjs(event.start).format("DD.MM.YYYY, HH:mm") }} -
                                {{ $dayjs(event.end).format("HH:mm") }}</span
                            >
                        </div>
                    </v-tooltip>
                </v-chip>
            </template>
        </v-calendar>
    </v-sheet>
</template>
<script setup lang="ts">
import { VCalendar } from "vuetify/labs/VCalendar";

const props = defineProps<{
    loading: boolean;
    data: Shared.ListData<Classes.ReadClassDTO> | null;
}>();

const value = ref(new Date());

const events = computed(() => {
    if (props.data) {
        return props.data.list.map((c: Classes.ReadClassDTO) => {
            return {
                title: c.lesson.title,
                classroom: c.classroom,
                start: new Date(Date.parse(c.begin_date)),
                end: new Date(Date.parse(c.begin_date) + 45 * c.lesson.hours_count * 60 * 1000)
            };
        });
    } else {
        return [];
    }
});
</script>
<style scoped>
::v-deep .v-chip__content {
    display: inline-block !important;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style>
