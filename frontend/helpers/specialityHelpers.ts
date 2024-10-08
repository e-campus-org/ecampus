export function createDefaultSpecialityDTO(): Specialities.CreateSpecialityDTO {
    return {
        code: '',
        description: '',
        title: '',
    };
}

export function updateDefaultSpecialityDTO(item?: Specialities.ReadSpecialityDTO): Specialities.UpdateSpecialityDTO {
    if (item) {
        return {
            code: item.code,
            description: item.description,
            title: item.title,
        };
    } else {
        return {
            code: '',
            description: '',
            title: '',
        };
    }
}
