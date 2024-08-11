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
        speciality_id: number;
        inserted_at: string;
        updated_at: string;
    }
}
