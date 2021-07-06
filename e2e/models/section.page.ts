export class SectionPage {
	constructor (
		public level: string,
		public dayOfWeek: string,
		public time: Date,
		public courseName: string,
		public semesterName: string,
		public meetings: string[],
	) {}
}
