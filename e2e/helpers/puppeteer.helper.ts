import * as puppeteer from 'puppeteer';
import { URL } from 'url';

export default class PuppeteerHelper {
  constructor(
    private page: puppeteer.Page,
  ) { }

  async clickLinkByText(text: string) {
    var txt = `//a[contains(., '${text}')]`;
    const [link] = await this.page.$x(txt);
    // TODO remove? this one seemed to take wayyy too long
    // const link = await this.page.waitForXPath(txt);
    if (!link) {
      throw new Error(`couldn't find link by text "${text}"`);
    }
    await link.click();
    await this.page.waitForNavigation();
  }

  async getTagTextContent(selector: string): Promise<string> {
    return this.page.evaluate(el => el.textContent, await this.page.$(selector));
  }
}
