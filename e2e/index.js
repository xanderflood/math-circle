const puppeteer = require('puppeteer');
const {TeacherAgent} = require('./agents/teacher');

(async function main(url){
  const browser = await puppeteer.launch({ headless: false });

  try {
    const page = await browser.newPage();

    const t = new TeacherAgent(page, url);

    console.log('signing in');
    await t.signIn("test@emory.edu", "password");

    console.log('creating a semester');
    const semesterId = await t.createSemester(new Date(2021, 0, 1), new Date(2021, 4, 1));
    console.log("semester id:", semesterId);

    console.log('creating a course');
    // TODO replace "1" with a level ID for a level created through this process
    const courseId = await t.createCourse(semesterId, 6, 7, "my course");
    console.log("course id:", courseId);

    console.log('done');
  } catch (error) {
    console.log(error);
  } finally {
    await browser.close();
  }
  // TODO parametrize
})("https://math-circle-staging.herokuapp.com");
