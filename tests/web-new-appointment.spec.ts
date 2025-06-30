import { test, expect } from '@playwright/test';
import { getRoundedFutureDateTimeLocalString } from './utils/time-utils';

test('Webpage has a title', async ({ page }) => {
  await page.goto('http://localhost:3000/appointments');

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Ambient Recording Web Client/);
});

test('Create a new appointment', async ({ page }) => {
  await page.goto('http://localhost:3000/appointments');

  // Click the new appointment button.
  await page.getByRole('button', { name: '+ New' }).click();

  // Expect URL to change
  await expect(page).toHaveURL('http://localhost:3000/appointments/new');

  // Expects page to have a heading with the name of New Appointment.
  await expect(page.getByRole('heading', { name: 'New Appointment' })).toBeVisible();

  // Fill in new appointment info
  await page.getByLabel('Patient Name').fill('Abby Anaesthesia');
  await page.getByLabel('Start Time').fill(getRoundedFutureDateTimeLocalString(30));
  await page.getByLabel('End Time').fill(getRoundedFutureDateTimeLocalString(60));
  await page.getByLabel('Notes (optional)').fill('First appointment with new patient; complaints of occasional numbness');

  // Create new appointment
  await page.getByRole('button', { name: 'Create Appointment' }).click();
  await expect(page.getByRole('heading', { name: 'Abby Anaesthesia' })).toBeVisible();

  // Get the new appointment ID
  const url = page.url();
  const match = url.match(/\/appointment\/([a-f0-9]{32})$/);
  expect(match).not.toBeNull();
  const appointmentId = match![1];
  console.log('Found appointment ID:', appointmentId);
  // Use it in another request/assertion
  await page.goto(`http://localhost:3000/appointment/${appointmentId}`);
  await expect(page.getByRole('heading', { name: 'Abby Anaesthesia' })).toBeVisible();
});
