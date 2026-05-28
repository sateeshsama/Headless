import { test, expect } from '@playwright/test';

test('Create Account via Lightning new record page', async ({ page }) => {
  const username = process.env.SF_USERNAME;
  const password = process.env.SF_PASSWORD;

  test.skip(!username || !password, 'Salesforce credentials not provided in environment (SF_USERNAME,SF_PASSWORD)');

  // Login to Salesforce
  await page.goto('https://login.salesforce.com');
  await page.getByLabel('Username').fill(username);
  await page.getByLabel('Password').fill(password);
  await page.getByRole('button', { name: 'Log In' }).click();

  // Ensure logged in and navigate to new Account page
  await page.waitForURL(/.*lightning.*/);
  const base = new URL(page.url()).origin;
  await page.goto(`${base}/lightning/o/Account/new`);

  const acctName = 'Playwright Created Account ' + Date.now();
  await page.getByLabel('Account Name').fill(acctName);
  await page.getByRole('button', { name: 'Save' }).click();

  // After save, record page loads with a heading that contains the account name
  await expect(page.getByRole('heading', { name: acctName })).toBeVisible({ timeout: 20000 });
});
