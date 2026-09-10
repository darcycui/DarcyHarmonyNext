
export class StudentEntity {
  name: string = ""
  age: number = 0

  constructor();
  constructor(name: string, age: number);

  constructor(name: string="", age: number=0) {
    this.name = name
    this.age = age
  }

  getName(): string {
    console.log(`do something...1`)
		return this.name
	}
  setName(name: string) {
		this.name = name
	}
  getAge(): number {
    console.log(`do something...2`)
		return this.age
	}
  setAge(age: number) {
		this.age = age
	}

}