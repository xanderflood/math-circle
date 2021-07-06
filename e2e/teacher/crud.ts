import * as puppeteer from 'puppeteer';
import { Navigator } from './navigate'
import { URL } from 'url';
import { SemesterPage } from '../models/semester.page';
import { CoursePage } from '../models/course.page';
import { SectionPage } from '../models/section.page';
import PuppeteerHelper from '../helpers/puppeteer.helper';

export class TeacherCrud {
  nav: Navigator
  ppth: PuppeteerHelper
  // baseURL: string;

  constructor(
    private page: puppeteer.Page,

    // TODO move all paths to the navigator
    private baseURL : string,
  ) {
    // TODO real dependency injection
    this.nav = new Navigator(page, baseURL)
    this.ppth = new PuppeteerHelper(page)
  }
 
  async signIn(username: string, password: string) {
    await this.page.goto(this.baseURL + '/teacher');
    await this.page.waitForSelector('form#new_teacher');

    await this.page.type('#teacher_email', username);
    await this.page.type('#teacher_password', password);
    await this.page.click('[type="submit"]');

    await this.page.waitForSelector('.notice');
  }

  // TODO move this and a SelectOptionByText to a Helpers class
  async clickLinkByText(text: string) {
    const link = await this.page.waitForXPath(`//a[contains(., '${text}')]`);
    if (!link) {
      throw new Error(`couldn't find link by text "${text}"`);
    }
    await link.click();
    await this.page.waitForNavigation();
  }

  ///////////////////
  // Semester CRUD //
  ///////////////////

  async createSemester(start: Date, end: Date): Promise<string> {
    await this.nav.navigateToNewSemesterForm();

    const name = generateRandomName();
    await this.page.type('input#semester_name', name);

    await this.fillSemeterForm(start, end);
    await this.page.click('[type="submit"]');

    return name;
  }

  async readSemester(name: string): Promise<SemesterPage> {
    await this.nav.navigateToSemester(name);

    try {
      var nameText = await this.ppth.getTagTextContent('h1');
      var listedName;
      [, listedName] = nameText.match(/Semester\: (.*)/);
    } catch {
      throw new Error("failed to find expected semester name text");
    }

    try {
      var dateText = await this.ppth.getTagTextContent('h4');
      var startText, endText;
      [, startText, endText] = dateText.match(/^(.*) to (.*)$/);

      var start = new Date(Date.parse(startText));
      var end = new Date(Date.parse(endText));
    } catch {
      throw new Error("failed to find expected semester date range text");
    }

    var availableActions = await this.page.evaluate(() => {
      var actions = [];
      var els = document.querySelectorAll('.semester-transition');
      for (var i = 0; i < els.length; i++) {
        actions.push(els[i].getAttribute('data-event'));
      }

      return actions;
    });

    return new SemesterPage(
      listedName,
      new Date(start),
      new Date(end),
      availableActions,
    );
  }

  async updateSemester(semesterName: string, start: Date, end: Date) {
    await this.nav.navigateToEditSemester(semesterName);

    const name = generateRandomName();
    await this.page.type('input#semester_name', name);

    await this.fillSemeterForm(start, end);
    await this.page.click('[type="submit"]');
  }

  /////////////////
  // Course CRUD //
  /////////////////

  async createCourse(semesterName: string, capacity: number, levelName: string, overview: string): Promise<string> {
    await this.nav.navigateToNewCoursePage(semesterName);

    await this.page.waitForSelector('form#new_course');

    await this.page.focus('input#course_capacity');
    for (let i = 0; i <= capacity - 1; i++) await this.page.keyboard.press('ArrowUp');

    const name = generateRandomName();
    await this.page.type('input#course_name', name);

    const option = await this.page.waitForXPath(`//*[@id = "course_level_id"]/option[text() = "${levelName}"]`);
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

  async readCourse(semesterName: string, name: string): Promise<CoursePage> {
    await this.nav.navigateToCourse(semesterName, name);

    try {
      var nameText = await this.ppth.getTagTextContent('h1');
      var listedName;
      [, listedName] = nameText.match(/Course\: (.*)/);
    } catch {
      throw new Error("failed to find expected course name text");
    }

    try {
      var dateText = await this.ppth.getTagTextContent('h4');
      var startText, endText;
      [, startText, endText] = dateText.match(/^\s*(.*) to (.*)\s*/m);
      var start = new Date(Date.parse(startText));
      var end = new Date(Date.parse(endText));
    } catch {
      throw new Error("failed to find expected course date range text");
    }

    try {
      var containerText = await this.ppth.getTagTextContent('.container');
      var overviewText;
      [, overviewText] = containerText.match(/^\s*Overview:\s*(.*)\s*$/m);
    } catch {
      throw new Error("failed to find expected course overview text");
    }

    return new CoursePage(
      listedName,
      new Date(start),
      new Date(end),
      overviewText,
    );
  }

  async createSection(semesterName: string, courseName: string, capacity: number, weekday: string, hour: number, minute: number): Promise<string> {
    await this.nav.navigateToNewSectionPage(semesterName, courseName);

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

  async readSection(semesterName: string, courseName: string, name: string): Promise<SectionPage> {
    await this.nav.navigateToSection(semesterName, courseName, name);

    try {
      var headerText = await this.ppth.getTagTextContent('h1');
      var level, dayOfWeek, hourText, minuteText, ampm;
      [, level, dayOfWeek, hourText, minuteText, ampm] =
        headerText.match(/^.* \(Level (.*)\) \- (.*) @ (\d+):(\d+) (.*)$/);

      const isPM = ampm.toLowerCase() == "pm";
      const hour = +hourText + (isPM ? 12 : 0);
      const minute = +minuteText;
      var time = new Date(`Sun Dec 31 1899 ${hour.toString().padStart(2, "0")}:${minute.toString().padStart(2, "0")}:00 GMT-0500`);
    } catch {
      throw new Error("failed to find expected section header text");
    }

    try {
      var subtitle = await this.ppth.getTagTextContent('.container h1 + p');
      var listedCourseName, listedSemesterName;
      [, listedCourseName, listedSemesterName] = subtitle.match(/a section of\s+(.*)\s+during semester\s+(.*)/m);
    } catch {
      throw new Error("failed to find expected course and semester text");
    }

    var listedMeetings = await this.page.evaluate(() => {
      var meetings = [];
      var els = (window as any)?.jQuery('tr :nth-child(1) a');
      for (var i = 0; i < els.length; i++) {
        meetings.push(els[i].text);
      }

      return meetings;
    });

    return new SectionPage(
      level,
      dayOfWeek,
      time,
      listedCourseName,
      listedSemesterName,
      listedMeetings,
    );
  }

  async addEventToSection(semesterName: string, courseName: string, sectionName: string, when: Date): Promise<string> {
    await this.nav.navigateToNewEventPage(semesterName, courseName, sectionName);

    const name = generateRandomName();
    await this.page.type("input#event_name", name);
    await this.page.select('select#event_when_1i', when.getFullYear().toString());
    await this.page.select('select#event_when_2i', (when.getMonth() + 1).toString());
    await this.page.select('select#event_when_3i', when.getDate().toString());
    await this.page.select('select#event_time_4i', when.getHours().toString().padStart(2, "0"));
    await this.page.select('select#event_time_5i', when.getMinutes().toString().padStart(2, "0"));

    await this.page.click('[type="submit"]');

    return name;
  }

  async deleteEventFromSection(semesterName: string, courseName: string, sectionName: string, eventName: string): Promise<any> {
    await this.nav.navigateToSection(semesterName, courseName, sectionName);

    const link = await this.page.waitForXPath(`//tr[contains(., '${eventName}')]/td/a[contains(., 'Delete')]`);
    if (!link) {
      throw new Error(`couldn't find event row "${eventName}"`);
    }
    this.page.on('dialog', (dialog) => dialog.accept());
    await link.click();

    return await this.page.waitForNavigation();
  }

  async rescheduleEvent(semesterName: string, courseName: string, sectionName: string, eventName: string, when: Date): Promise<any> {
    await this.nav.navigateToEventEditPage(semesterName, courseName, sectionName, eventName);

    await this.page.select('select#event_when_1i', when.getFullYear().toString());
    await this.page.select('select#event_when_2i', (when.getMonth() + 1).toString());
    await this.page.select('select#event_when_3i', when.getDate().toString());
    await this.page.select('select#event_time_4i', when.getHours().toString().padStart(2, "0"));
    await this.page.select('select#event_time_5i', when.getMinutes().toString().padStart(2, "0"));

    await this.page.click('[type="submit"]');

    return await this.page.waitForNavigation();
  }

  async createSpecialEvent(semesterName: string, capacity: number, start: Date, end: Date, description: string): Promise<any> {
    await this.nav.navigateToNewSpecialEvent(semesterName);

    const name = generateRandomName();
    await this.page.type('input#special_event_name', name);

    await this.page.type("input#special_event_capacity", capacity.toString());

    await this.page.select('select#special_event_date_1i', start.getFullYear().toString());
    await this.page.select('select#special_event_date_2i', (start.getMonth() + 1).toString());
    await this.page.select('select#special_event_date_3i', start.getDate().toString());
    await this.page.select('select#special_event_start_4i', start.getHours().toString().padStart(2, "0"));
    await this.page.select('select#special_event_start_5i', start.getMinutes().toString().padStart(2, "0"));

    await this.page.select('select#special_event_end_4i', end.getHours().toString().padStart(2, "0"));
    await this.page.select('select#special_event_end_5i', end.getMinutes().toString().padStart(2, "0"));
    await this.page.type("input#special_event_description", description);

    await this.page.click('[type="submit"]');

    return await this.page.waitForNavigation();
  }

  async createLevel(position: number, restricted: boolean, active: boolean, minGrade: string, maxGrade: string): Promise<string> {
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

  // async advanceGenericSemesterState(eventName: string) {
  //   //
  // }

  // async runLottery() {
  //   //
  // }

  // form fillers //
  private async fillSemeterForm(start: Date, end: Date) {
    await this.page.select('select#semester_start_1i', start.getFullYear().toString());
    await this.page.select('select#semester_start_2i', (start.getMonth() + 1).toString());
    await this.page.select('select#semester_start_3i', start.getDate().toString());
    await this.page.select('select#semester_end_1i', end.getFullYear().toString());
    await this.page.select('select#semester_end_2i', (end.getMonth() + 1).toString());
    await this.page.select('select#semester_end_3i', end.getDate().toString());
  }
}

function generateRandomName(): string {
  return Math.floor(Math.random() * Math.floor(10000000)).toString();
}
