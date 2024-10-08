export function createDefaultSubjectDTO(): Subjects.CreateSubjectDTO {
    return {
        title: '',
        short_title: '',
        description: '',
        objectives: '',
        prerequisites: '',
        required_texts: '',
        teachers: [],
    };
}

export function updateDefaultSubjectDTO(item?: Subjects.ReadSubjectDTO): Subjects.UpdateSubjectDTO {
    if (item) {
        return {
            title: item.title,
            short_title: item.short_title,
            description: item.description,
            objectives: item.objectives,
            prerequisites: item.prerequisites,
            required_texts: item.required_texts,
        };
    } else {
        return {
            title: '',
            short_title: '',
            description: '',
            objectives: '',
            prerequisites: '',
            required_texts: '',
        };
    }
}
