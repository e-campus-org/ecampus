<template>
    <v-row>
        <v-col cols="12" md="4" xl="3">
            <v-card :title="$t('components.widgets.my.class.info')" prepend-icon="mdi-clock">
                <v-card-text>
                    <p class="text-h5 font-weight-black">{{ currentClass?.lesson?.title || "" }}</p>
                    <p class="my-2 text-medium-emphasis">{{ currentClass?.lesson?.topic || "" }}</p>
                </v-card-text>
                <v-card-text>
                    <v-row align="center">
                        <v-col class="text-h3" cols="12"> {{ currentClass?.classroom }} </v-col>
                        <v-col cols="6">
                            <p>
                                {{
                                    $t("components.widgets.my.class.group", { group: currentClass?.group?.title || "" })
                                }}
                            </p>
                            <p>
                                {{
                                    $t("components.widgets.my.class.date", {
                                        date: currentClass?.begin_date
                                            ? $dayjs(currentClass?.begin_date).format("DD.MM.YYYY")
                                            : ""
                                    })
                                }}
                            </p>
                        </v-col>
                        <v-col cols="6">
                            <p>
                                {{
                                    $t("components.widgets.my.class.begin", {
                                        begin: currentClass?.begin_date
                                            ? $dayjs(currentClass?.begin_date).format("HH:mm")
                                            : ""
                                    })
                                }}
                            </p>
                            <p>
                                {{
                                    $t("components.widgets.my.class.end", {
                                        end: currentClass?.begin_date
                                            ? $dayjs(currentClass?.begin_date)
                                                  .add((currentClass?.lesson?.hours_count || 0) * 45, "minutes")
                                                  .format("HH:mm")
                                            : ""
                                    })
                                }}
                            </p>
                        </v-col>
                    </v-row>
                </v-card-text>
                <v-card-item :title="$t('components.widgets.my.class.subjectProfessors')">
                    <p v-for="teacher of currentClass?.lesson.teachers" :key="teacher.id">
                        {{ `${teacher.first_name} ${teacher.last_name}` }}
                    </p>
                </v-card-item>
                <v-card-item
                    v-if="currentClass?.teachers?.length && currentClass?.teachers?.length > 0"
                    :title="$t('components.widgets.my.class.leadingProfessors')"
                >
                    <p v-for="teacher of currentClass?.teachers" :key="teacher.id">
                        {{ `${teacher.first_name} ${teacher.last_name}` }}
                    </p>
                </v-card-item>
            </v-card>
            <v-card class="mt-6" :title="$t('components.widgets.my.class.topics')" prepend-icon="mdi-list-status">
                <v-card-item>
                    <v-timeline align="start" density="compact">
                        <v-timeline-item v-for="topic in currentClass?.lesson?.topics" :key="topic.id" size="x-small">
                            <div class="mb-4">
                                <div class="font-weight-normal">
                                    {{ topic.title }}
                                </div>
                                <v-btn variant="plain" @click="onCurrentTopicChanged(topic)">{{
                                    $t("components.widgets.my.class.openTopic")
                                }}</v-btn>
                            </div>
                        </v-timeline-item>
                    </v-timeline>
                </v-card-item>
            </v-card>
        </v-col>
        <v-col v-if="currentTopic" cols="12" md="8" xl="9">
            <v-card>
                <v-card-text>
                    <p class="text-h5 font-weight-black">{{ currentTopic.title || "" }}</p>
                </v-card-text>
                <v-card-text>
                    <tiptap-viewer :content="currentTopic.content" />
                </v-card-text>
            </v-card>
        </v-col>
    </v-row>
</template>
<script setup lang="ts">
import { TiptapViewer } from "@/components/shared";

const props = defineProps<{
    loading: boolean;
    currentClass: Classes.ReadClassDTO | null;
}>();

const currentTopic = ref<Classes.ReadClassLessonTopicInfoDTO | null>(null);

function onCurrentTopicChanged(topic: Classes.ReadClassLessonTopicInfoDTO) {
    currentTopic.value = topic;
}

watchEffect(() => {
    if (props.currentClass) {
        currentTopic.value = props.currentClass.lesson.topics[0];
    }
});
</script>
