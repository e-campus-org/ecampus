export function createDefaultAccountDTO(): Accounts.CreateAccountDTO {
    return {
        email: '',
        first_name: '',
        last_name: '',
        group_id: null,
        roles: [],
        password: '',
        password_confirm: ''
    };
}

export function updateDefaultAccountDTO(item?: Accounts.ReadAccountDTO): Accounts.UpdateAccountDTO {
    if (item) {
        return {
            email: item.email,
            first_name: item.first_name,
            last_name: item.last_name,
            group_id: item.group_id,
            roles: item.roles,
        };
    } else {
        return {
            email: '',
            first_name: '',
            last_name: '',
            group_id: null,
            roles: [],
        };
    }
}
