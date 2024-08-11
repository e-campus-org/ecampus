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

declare namespace Common {
    interface Notification {
        text: string;
        timeout: number;
        color: string;
    }
}

declare namespace Account {
    type Role = "admin" | "teacher" | "student";
}
