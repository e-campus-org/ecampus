<template>
    <v-card :title="$t('components.widgets.my.class.info')" prepend-icon="mdi-clock">
        <v-card-text>
            <p class="text-h5 font-weight-black">{{ currentClass?.lesson?.title || "" }}</p>
            <p class="my-2 text-medium-emphasis">{{ currentClass?.lesson?.topic || "" }}</p>
        </v-card-text>
        <v-card-text>
            <v-row align="center">
                <v-col class="text-h3" cols="12" md="4"> {{ currentClass?.classroom }} </v-col>
                <v-col cols="12" sm="6" md="4">
                    <p>
                        {{
                            $t("components.widgets.my.class.group", {
                                group: currentClass?.group?.title || ""
                            })
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
                <v-col cols="12" sm="6" md="4">
                    <p>
                        {{
                            $t("components.widgets.my.class.begin", {
                                begin: currentClass?.begin_date ? $dayjs(currentClass?.begin_date).format("HH:mm") : ""
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
</template>
<script setup lang="ts">
defineProps<{
    loading: boolean;
    currentClass: Classes.ReadClassDTO | null;
}>();
</script>
