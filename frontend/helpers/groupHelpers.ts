export function createDefaultGroupDTO(): Groups.CreateGroupDTO {
    return {
        title: '',
        description: '',
        speciality_id: null,
    };
}

export function updateDefaultGroupDTO(item?:Groups.ReadGroupDTO): Groups.UpdateGroupDTO {
    if (item) {
        return {
            title: item.title,
            description: item.description,
            speciality_id: item.speciality_id,
        };
    } else {
        return {
            title: '',
            description: '',
            speciality_id: null,
        };
    }
}
