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
}
