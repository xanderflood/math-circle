import * as puppeteer from 'puppeteer';
import PuppeteerHelper from '../helpers/puppeteer.helper'
import { URL } from 'url';

export class Navigator {
  ppth: PuppeteerHelper

  constructor(
    private page : puppeteer.Page,
    private baseURL : string,
  ) {
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

  async navigateToNewSemesterForm() {
    await this.page.goto(this.baseURL + '/teacher/semesters/new');
  }

  async navigateToSemester(semesterName: string) {
    await this.page.goto(this.baseURL + '/teacher/semesters');
    await this.ppth.clickLinkByText(semesterName);
  }

  async navigateToEditSemester(semesterName: string) {
    await this.navigateToSemester(semesterName);
    await this.ppth.clickLinkByText("Edit");
  }

  async navigateToCourse(semesterName: string, courseName: string) {
    await this.navigateToSemester(semesterName);
    await this.ppth.clickLinkByText(courseName);
  }

  async navigateToSection(semesterName: string, courseName: string, sectionName: string) {
    await this.navigateToCourse(semesterName, courseName);
    await this.ppth.clickLinkByText(sectionName);
  }

  async navigateToNewCoursePage(semesterName: string) {
    await this.navigateToSemester(semesterName);
    try {
      await this.ppth.clickLinkByText("New Course");
    } catch (error) {
      await this.ppth.clickLinkByText("Add a new course.");
    }
  }

  async navigateToNewSectionPage(semesterName: string, courseName: string) {
    await this.navigateToCourse(semesterName, courseName);
    try {
      await this.ppth.clickLinkByText("New Section");
    } catch (error) {
      await this.ppth.clickLinkByText("Add a new Section.");
    }
  }

  async navigateToNewEventPage(semesterName: string, courseName: string, sectionName: string) {
    await this.navigateToSection(semesterName, courseName, sectionName);
    await this.ppth.clickLinkByText("New Meeting");
  }

  async navigateToEventPage(semesterName: string, courseName: string, sectionName: string, eventName: string) {
    await this.navigateToSection(semesterName, courseName, sectionName);
    await this.ppth.clickLinkByText(eventName);
  }

  async navigateToEventEditPage(semesterName: string, courseName: string, sectionName: string, eventName: string) {
    await this.navigateToEventPage(semesterName, courseName, sectionName, eventName);
    await this.ppth.clickLinkByText('Edit');
  }

  async navigateToNewSpecialEvent(semesterName: string) {
    await this.navigateToSemester(semesterName);
    await this.ppth.clickLinkByText('Add a new special event');
  }
}
