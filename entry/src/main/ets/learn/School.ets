export class Teacher {
  name: string | null = null

  constructor()

  constructor(name: string | null)

  constructor(name: string | null = null) {
    this.name = name
  }
}

export class School {
  // 属性未初始化 可以是undefined
  teacher?: Teacher

  setTeacher(teacher: Teacher) {
    this.teacher = teacher
  }

  getTeacherName(): string | undefined | null {
    return this.teacher?.name ?? "Default name"
  }
}