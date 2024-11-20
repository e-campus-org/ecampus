type Locale = "en" | "ru";

declare namespace JWT {
    interface AccountInfo {
        id: number;
        email: string;
        roles: Account.Role[];
    }
    interface Payload {
        account: AccountInfo;
        aud: string;
        exp: number;
        iat: number;
        iss: string;
        jti: string;
        nbf: number;
        sub: string;
        type: string;
    }
}

declare namespace Shared {
    interface Notification {
        text: string;
        timeout: number;
        color: string;
    }

    interface Pagination {
        count: number;
        page: number;
        page_size: number;
        pages: number;
    }

    interface ListData<T> {
        pagination: Pagination;
        list: Array<T>;
    }
}

declare namespace Account {
    type Role = "admin" | "teacher" | "student";
}

declare namespace Specialities {
    interface ReadSpecialityDTO {
        id: 1;
        code: string;
        description: string;
        title: string;
        inserted_at: string;
        updated_at: string;
    }

    interface CreateSpecialityDTO {
        code: string;
        description: string;
        title: string;
    }

    interface UpdateSpecialityDTO {
        code?: string;
        description?: string;
        title?: string;
    }
}

declare namespace Groups {
    interface ReadGroupDTO {
        id: 1;
        title: string;
        description: string;
        speciality_id: number | null;
        inserted_at: string;
        updated_at: string;
    }

    interface CreateGroupDTO {
        title: string;
        description: string;
        speciality_id: number | null;
    }

    interface UpdateGroupDTO {
        title?: string;
        description?: string;
        speciality_id?: number | null;
    }
}

declare namespace Accounts {
    interface ReadAccountDTO {
        id: 1;
        email: string;
        first_name: string;
        last_name: string;
        group_id: number | null;
        roles: string[];
        inserted_at: string;
        updated_at: string;
    }

    interface CreateAccountDTO {
        email: string;
        first_name: string;
        last_name: string;
        group_id: number | null;
        roles: string[];
        password: string;
        password_confirm: string;
    }

    interface UpdateAccountDTO {
        first_name?: string;
        last_name?: string;
        group_id?: number | null;
        roles?: string[];
        email?: string;
    }
}

declare namespace Subjects {
    interface ReadSubjectDTO {
        id: number;
        title: string;
        short_title: string;
        description: string;
        objectives: string;
        prerequisites: string;
        required_texts: string;
        inserted_at: string;
        updated_at: string;
    }

    interface CreateSubjectDTO {
        title: string;
        short_title: string;
        description: string;
        objectives: string;
        prerequisites: string;
        required_texts: string;
        teachers: string[];
    }

    interface UpdateSubjectDTO {
        title?: string;
        short_title?: string;
        description?: string;
        objectives?: string;
        prerequisites?: string;
        required_texts?: string;
    }
}

declare namespace Lessons {
    interface CreateLessonDTO {
        is_draft: boolean;
        // objectives: string;
        subject_id: number;
        title: string;
        topic: string;
        hours_count: number;
    }

    interface UpdateLessonDTO {
        is_draft?: boolean;
        objectives?: string;
        subject_id?: number;
        title?: string;
        topic?: string;
        hours_count?: number;
    }

    interface ReadLessonDTO extends CreateLessonDTO {
        id: number;
        inserted_at: string;
        updated_at: string;
    }

    interface CreateLessonTopicDTO {
        title: string;
        content: string;
        lesson_id: number;
    }

    interface UpdateLessonTopicDTO {
        title?: string;
        content?: string;
        lesson_id?: number;
    }

    interface ReadLessonTopicDTO extends CreateLessonTopicDTO {
        id: number;
        inserted_at: string;
        updated_at: string;
    }
}

declare namespace Classes {
    interface ReadClassGroupInfoDTO {
        id: number;
        title: string;
    }

    interface ReadClassTeacherDTO {
        id: number;
        first_name: string;
        last_name: string;
    }

    interface ReadClassLessonTopicInfoDTO {
        id: number;
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        content: any;
        title: string;
        lesson_id: number;
        inserted_at: string;
        updated_at: string;
    }

    interface ReadClassQuizQuestionAnswerDTO {
        id: number;
        title: string;
        subtitle: string;
    }

    interface ReadQuizQuestionYourAnswerDTO {
        answer_id?: number;
        answer_ids?: number[];
        grade: number;
        correct: number | number[];
    }

    interface ReadClassQuizQuestionDTO {
        id: number;
        type: "single" | "multiple" | "open" | "sequence" | "fill";
        title: string;
        subtitle: string;
        grade: number;
        quiz_id: number;
        order: number;
        answers: ReadClassQuizQuestionAnswerDTO[];
        your_answer: ReadQuizQuestionYourAnswerDTO[];
    }

    interface ReadClassQuizDTO {
        id: number;
        title: string;
        description: string;
        lesson_id: number;
        questions: ReadClassQuizQuestionDTO[];
        estimation: Record<string, number>;
    }

    interface ReadClassLessonInfoDTO {
        id: number;
        title: string;
        topic: string;
        topics: ReadClassLessonTopicInfoDTO[];
        teachers: ReadClassTeacherDTO[];
        quizzes: ReadClassQuizDTO[];
        hours_count: number;
        subject_id: number;
    }
    interface ReadClassDTO {
        id: number;
        begin_date: string;
        classroom: string;
        group: ReadClassGroupInfoDTO;
        lesson: ReadClassLessonInfoDTO;
        teachers: ReadClassTeacherDTO[];
        inserted_at: string;
        updated_at: string;
    }

    interface CreateSingleQuestionAnswerDTO {
        answer_id: number;
    }

    interface CreateMultipleQuestionAnswerDTO {
        answer_ids: number[];
    }
}
