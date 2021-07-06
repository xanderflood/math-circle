#!/usr/bin/env ts-node-script

import * as puppeteer from 'puppeteer';
import { expect, use } from 'chai';
import { TeacherCrud } from './teacher/crud';
const fs = require('fs');

use(require('chai-string'));

interface Config {
    email: string;
    password: string;
    url: string;
}

let config = JSON.parse(fs.readFileSync('config.json')) as Config;

async function sleep(ms) : Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

(async function main(config: Config){
  const browser = await puppeteer.launch({ headless: false });

  try {
    const [page] = await browser.pages();

    const t = new TeacherCrud(page, config.url);

    console.log('signing in');
    await t.signIn(config.email, config.password);

    console.log('creating a semester');
    var semesterStart = new Date(2021, 0, 1);
    var semesterEnd = new Date(2021, 2, 1);
    const semesterName = await t.createSemester(semesterStart, semesterEnd);
    console.log("semester name:", semesterName);

    await sleep(1000);

    var semester = await t.readSemester(semesterName);
    expect(semester.name).to.equal(semesterName);
    expect(semester.start).to.deep.equal(semesterStart);
    expect(semester.end).to.deep.equal(semesterEnd);
    expect(semester.actions).to.deep.equal(["publish"]);

    console.log('creating a level');
    const levelName = await t.createLevel(3, true, true, "4", "7");
    console.log("level name:", levelName);

    // TODO assertions

    // TODO reordering

    console.log('creating a course');
    const courseName1 = await t.createCourse(semesterName, 6, levelName, "my course");
    console.log("course name:", courseName1);

    var course = await t.readCourse(semesterName, courseName1);
    expect(course.name).to.equal(courseName1);
    expect(course.start).to.deep.equal(semesterStart);
    expect(course.end).to.deep.equal(semesterEnd);
    expect(course.overview).to.equal("my course");

    console.log('creating another course');
    const courseName2 = await t.createCourse(semesterName, 6, levelName, "my other course");
    console.log("course name:", courseName2);

    var course = await t.readCourse(semesterName, courseName2);
    expect(course.name).to.equal(courseName2);
    expect(course.start).to.deep.equal(semesterStart);
    expect(course.end).to.deep.equal(semesterEnd);
    expect(course.overview).to.equal("my other course");

    console.log('creating a section');
    const sectionName = await t.createSection(semesterName, courseName2, 5, "monday", 8, 30)
    console.log("section name:", sectionName);

    var section = await t.readSection(semesterName, courseName2, sectionName);
    expect(section.level).to.equal(levelName);
    expect(section.dayOfWeek).to.equal("monday");
    expect(section.time.getHours()).to.equal(8);
    expect(section.time.getMinutes()).to.equal(30);
    expect(section.courseName).to.equal(courseName2);
    expect(section.semesterName).to.equal(semesterName);
    expect(section.meetings.length).to.equal(9);
    expect(section.meetings[0]).to.equal("Monday January 04, 2021 @ 08:30 AM");
    expect(section.meetings[8]).to.equal("Monday March 01, 2021 @ 08:30 AM");

    const eventName1 = await t.addEventToSection(semesterName, courseName2, sectionName, new Date(2020, 1, 5, 15, 7));
    const eventName2 = await t.addEventToSection(semesterName, courseName2, sectionName, new Date(2020, 1, 6, 15, 7));
    console.log("event name 1:", eventName1);
    console.log("event name 2:", eventName2);

    // TODO check that the section time hasn't changed; pending bug fix
    // TODO fix sorting
    section = await t.readSection(semesterName, courseName2, sectionName);
    expect(section.meetings.length).to.equal(11);
    expect(section.meetings[0]).to.equal(`${eventName1} - Wednesday February 05, 2020 @ 03:07 PM`);
    expect(section.meetings[1]).to.equal(`${eventName2} - Thursday February 06, 2020 @ 03:07 PM`);
    expect(section.meetings[2]).to.equal("Monday January 04, 2021 @ 08:30 AM");
    expect(section.meetings[10]).to.equal("Monday March 01, 2021 @ 08:30 AM");

    await t.deleteEventFromSection(semesterName, courseName2, sectionName, eventName1);
    await t.rescheduleEvent(semesterName, courseName2, sectionName, eventName2, new Date(2020, 1, 5, 15, 8));

    section = await t.readSection(semesterName, courseName2, sectionName);
    expect(section.meetings.length).to.equal(10);
    expect(section.meetings[0]).to.equal(`${eventName2} - Wednesday February 05, 2020 @ 03:08 PM`);
    expect(section.meetings[1]).to.equal("Monday January 04, 2021 @ 08:30 AM");
    expect(section.meetings[9]).to.equal("Monday March 01, 2021 @ 08:30 AM");

    // TODO check now that the one section WAS deleted and the other was updated

    await t.createSpecialEvent(semesterName, 3, new Date(2020, 1, 5, 15, 8), new Date(2020, 1, 5, 15, 38), 'a fun time!');
    // TODO set up special events
    // TODO start adding assertions and reorganizing!

    console.log('done');
  } catch (error) {
    console.log(error);
  } finally {
    // await browser.close();
  }
  // TODO parametrize
})(config);
