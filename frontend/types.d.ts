type Locale = "en" | "ru";

declare namespace JWT {
    interface Payload {
        sub: string;
        exp: number;
        roles: Client.Role[];
        id: number;
        username: string;
        firstName: string;
        lastName: string;
    }
}
