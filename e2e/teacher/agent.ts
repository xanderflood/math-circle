import * as puppeteer from 'puppeteer';
import { Navigator } from './navigate'
import { URL } from 'url';

export class TeacherAgent {
  page: puppeteer.Page;
  nav: Navigator;
  baseURL: string;

  constructor(
    page : puppeteer.Page,
    baseURL : string,
  ) {
    this.baseURL = baseURL;
    this.page = page;
  }

  async signIn(username: string, password: string) {
    await this.page.goto(this.baseURL + '/teacher');
    await this.page.waitForSelector('form#new_teacher');

    await this.page.type('#teacher_email', username);
    await this.page.type('#teacher_password', password);
    await this.page.click('[type="submit"]');

    await this.page.waitForSelector('.notice');
  }

  async createSemester(start: Date, end: Date) {
    await this.page.goto(this.baseURL + '/teacher/semesters/new');
    await this.page.waitForSelector('form#new_semester');

    const name = generateRandomName();
    await this.page.type('input#semester_name', name);

    await this.page.select('select#semester_start_1i', start.getFullYear().toString());
    await this.page.select('select#semester_start_2i', (start.getMonth() + 1).toString());
    await this.page.select('select#semester_start_3i', start.getDate().toString());
    await this.page.select('select#semester_end_1i', end.getFullYear().toString());
    await this.page.select('select#semester_end_2i', (end.getMonth() + 1).toString());
    await this.page.select('select#semester_end_3i', end.getDate().toString());

    await this.page.click('[type="submit"]');
    await this.page.waitForNavigation();

    return name;
  }

  async createLevel(position: number, restricted: boolean, active: boolean, minGrade: string, maxGrade: string) {
    await this.page.goto(this.baseURL + '/teacher/levels');
    await this.page.waitForSelector('table.level-table');

    await this.page.click('input.create');
    const row = await this.page.waitForSelector('tr.row_with_errors');

    const name = generateRandomName();
    await (await row.$('input.name')).type(name);
    

    await (await row.$('select.min-grade')).select(minGrade);
    await (await row.$('select.max-grade')).select(maxGrade);

    if (restricted) await (await row.$('input.restricted')).click();
    if (!active) await (await row.$('input.active')).click();

    await this.page.click("input.submit");
    await this.page.waitForNavigation();
    await this.page.waitForSelector('table.level-table');
    return name;
  }

  async createCourse(semesterName: string, capacity: number, levelName: string, overview: string) {
    await this.navigateToNewCoursePage(semesterName);

    await this.page.waitForSelector('form#new_course');

    await this.page.focus('input#course_capacity');
    for (let i = 0; i <= capacity - 1; i++) await this.page.keyboard.press('ArrowUp');

    const name = generateRandomName();
    await this.page.type('input#course_name', name);

    const [option] = await this.page.waitForXPath(`//*[@id = "course_level_id"]/option[text() = "${levelName}"]`);
    if (!option) {
      throw new Error("couldn't find select option");
    }
    const levelId = <string>await (await option.getProperty('value')).jsonValue();
    await this.page.select("select#course_level_id", levelId);

    await this.page.type('textarea#course_overview', overview);

    await this.page.click('[type="submit"]');
    await this.page.waitForSelector('.notice');

    return name;
  }

  async createSection(semesterName: string, courseName: string, capacity: number, weekday: string, hour: number, minute: number) {
    await this.navigateToNewSectionPage(semesterName, courseName);

    await this.page.type("input#event_group_capacity", capacity.toString());
    await this.page.select("select#event_group_wday", weekday.toLowerCase());
    await this.page.select("select#event_group_event_time_4i", hour.toString().padStart(2, "0"));
    await this.page.select("select#event_group_event_time_5i", minute.toString().padStart(2, "0"));

    await this.page.click('[type="submit"]');

    // The full name includes the course's level and a tricky formatted date,
    // so for testing purposes, we'll just keep all sections of the same course
    // on different days of the week.
    return weekday;
  }

  async addEventToSection(semesterName: string, courseName: string, sectionName: string, when: Date) {
    await this.navigateToNewEventPage(semesterName, courseName, sectionName);

    const name = generateRandomName();
    await this.page.type("input#event_name", name);
    await this.page.select('select#event_when_1i', when.getFullYear().toString());
    await this.page.select('select#event_when_2i', (when.getMonth() + 1).toString());
    await this.page.select('select#event_when_3i', when.getDate().toString());
    await this.page.select('select#event_time_4i', when.getHours().toString().padStart(2, "0"));
    await this.page.select('select#event_time_5i', when.getMinutes().toString().padStart(2, "0"));

    await this.page.click('[type="submit"]');
    await this.page.waitForNavigation();

    return name;
  }

  async advanceGenericSemesterState(eventName: string) {
    //
  }

  async runLottery() {
    //
  }
}

function generateRandomName(): string {
  return Math.floor(Math.random() * Math.floor(10000000)).toString();
}

function matchURLPath(url, pattern) {
  const path = (new URL(url)).pathname;
  const match = path.match(pattern);
  if (!match) throw new Error(`URL ${url} did not match ${pattern}`)

  return match[1];
}
