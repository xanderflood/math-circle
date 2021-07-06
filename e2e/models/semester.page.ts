export class SemesterPage {
	constructor (
		public name: string,
		public start: Date,
		public end: Date,
		public actions: string[],
	) {}
}
