const { URL } = require('url');

class TeacherAgent {
  constructor(page, baseURL) {
    this.baseURL = baseURL;
    this.page = page;
  }

  async signIn(username, password) {
    await this.page.goto(this.baseURL + '/teacher');
    await this.page.waitForSelector('form#new_teacher');

    await this.page.type('#teacher_email', username);
    await this.page.type('#teacher_password', password);
    await this.page.click('[type="submit"]');

    await this.page.waitForSelector('.notice');
  }

  // TODO for now, just do creates.
  // Eventually, add _all_ CRUD operations
  // TODO levels

  async createSemester(start, end) {
    await this.page.goto(this.baseURL + '/teacher/semesters/new');
    await this.page.waitForSelector('form#new_semester');

    const name = getRandomInt(10000000).toString();
    await this.page.type('input#semester_name', name);

    await this.page.select('select#semester_start_1i', start.getFullYear().toString());
    await this.page.select('select#semester_start_2i', (start.getMonth() + 1).toString());
    await this.page.select('select#semester_start_3i', start.getDate().toString());
    await this.page.select('select#semester_end_1i', end.getFullYear().toString());
    await this.page.select('select#semester_end_2i', (end.getMonth() + 1).toString());
    await this.page.select('select#semester_end_3i', end.getDate().toString());

    await this.page.click('[type="submit"]');

    // navigate through the reset-priorities page
    await this.page.waitForSelector('input#threshold');

    // now we have to find the semester on the semesters page
    await this.page.goto(this.baseURL + '/teacher/semesters');
    const [link] = await this.page.$x(`//a[contains(., '${name}')]`);
    if (!link) {
      throw new Error("couldn't find newly created semester");
    }

    const propHandle = await link.getProperty('href');
    const value = await propHandle.jsonValue();
    const semesterId = matchURLPath(value, /\/teacher\/semesters\/(\d+)/);
    return semesterId;
  }

  async createCourse(semesterId, capacity, levelId, overview) {
    const url = this.baseURL + '/teacher/courses/new?semester_id=' + semesterId;
    await this.page.goto(url);

    await this.page.waitForSelector('form#new_course');

    await this.page.focus('input#course_capacity');
    for (let i = 0; i <= capacity - 1; i++) await this.page.keyboard.press('ArrowUp');

    const name = getRandomInt(10000000).toString();
    await this.page.type('input#course_name', name);
    await this.page.select('select#course_level_id', levelId.toString());
    await this.page.type('textarea#course_overview', overview);

    await this.page.click('[type="submit"]');
    await this.page.waitForSelector('.notice');

    const [link] = await this.page.$x(`//a[contains(., '${name}')]`);
    if (!link) {
      throw new Error("couldn't find newly created semester");
    }

    const propHandle = await link.getProperty('href');
    const value = await propHandle.jsonValue();
    const courseId = matchURLPath(value, /\/teacher\/courses\/(\d+)/);
    return courseId;
  }

  async addSectionToCourse() {
    //
  }

  async addEventToSection() {
    //
  }

  async advanceGenericSemesterState(eventName) {
    //
  }

  async runLottery() {
    //
  }
}

module.exports = { TeacherAgent };

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

function matchURLPath(url, pattern) {
  const path = (new URL(url)).pathname;
  const match = path.match(pattern);
  if (!match) throw new Error(`URL ${url} did not match ${pattern}`)

  return match[1];
}