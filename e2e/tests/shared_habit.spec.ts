import { test, expect, BrowserContext, Page } from '@playwright/test';

// Use a random suffix to avoid collisions during repeated tests
const RUN_ID = Date.now();
const ALICE_USERNAME = `Alice_${RUN_ID}`;
const BOB_USERNAME = `Bob_${RUN_ID}`;
const HABIT_NAME = `E2E Shared Habit ${RUN_ID}`;

async function registerUser(page: Page, username: string) {
  await page.goto('/');
  // Assume app routes unauthenticated users to an Auth screen.
  // We need to click "Sign up" if we are on Login.
  const signUpSwitch = page.locator('text="Need an account? Sign up"');
  if (await signUpSwitch.isVisible()) {
    await signUpSwitch.click();
  }

  // Assuming the UI has placeholders 'Username' and 'Password'
  await page.fill('input[placeholder="Username"]', username);
  await page.fill('input[placeholder="Password"]', 'password123');
  await page.click('button:has-text("Sign Up")');

  // Wait to reach the Home dashboard.
  await expect(page.locator('text="Home"').first()).toBeVisible({ timeout: 10000 });
}

test.describe('Multi-User Shared Habit Flow', () => {
  let aliceContext: BrowserContext;
  let bobContext: BrowserContext;
  let alicePage: Page;
  let bobPage: Page;

  test.beforeAll(async ({ browser }) => {
    // Create two entirely isolated browser contexts
    aliceContext = await browser.newContext();
    bobContext = await browser.newContext();
    alicePage = await aliceContext.newPage();
    bobPage = await bobContext.newPage();
  });

  test.afterAll(async () => {
    await aliceContext.close();
    await bobContext.close();
  });

  test('Alice and Bob register', async () => {
    await registerUser(alicePage, ALICE_USERNAME);
    await registerUser(bobPage, BOB_USERNAME);
  });

  test('Alice sends friend request to Bob', async () => {
    // Navigate to Social Hub
    await alicePage.click('text="Social"');
    
    // Open Find Friends sheet (assume clicking a search icon or button)
    // The UI may have an explicit "Find Friends" button or aria-label
    // Assuming generic placeholder for search input
    await alicePage.click('button[aria-label="Find Friends"], text="Find Friends"');
    
    // Search for Bob
    await alicePage.fill('input[placeholder="Search username..."]', BOB_USERNAME);
    // Tap the search action
    await alicePage.press('input[placeholder="Search username..."]', 'Enter');

    // Wait for result and click add
    const addFriendButton = alicePage.locator('button:has-text("Add Friend")').first();
    await expect(addFriendButton).toBeVisible();
    await addFriendButton.click();

    // Verify it changed to requested
    await expect(alicePage.locator('text="Requested"').first()).toBeVisible();
  });

  test('Bob accepts friend request', async () => {
    // Bob goes to Social -> Requests
    await bobPage.click('text="Social"');
    await bobPage.click('text="Activity"'); // or 'Requests' depending on the UI
    
    // Find Alice's request and accept
    const acceptButton = bobPage.locator(`text=${ALICE_USERNAME}`).locator('..').locator('button:has-text("Accept")');
    await expect(acceptButton).toBeVisible();
    await acceptButton.click();

    // Verify acceptance (maybe it disappears or shows "Accepted")
    await expect(bobPage.locator(`text=${ALICE_USERNAME}`).locator('..').locator('text="Accepted"')).toBeVisible();
  });

  test('Alice creates shared habit and invites Bob', async () => {
    // Alice goes Home
    await alicePage.click('text="Home"');
    
    // Open Habit creation
    await alicePage.click('button[aria-label="Add Habit"], text="Add habit"');
    
    // Fill title
    await alicePage.fill('input[placeholder="Habit title"]', HABIT_NAME);

    // Select Bob as partner
    // We assume Bob appears in a list of accepted friends
    const bobChip = alicePage.locator(`text=${BOB_USERNAME}`);
    await expect(bobChip).toBeVisible();
    await bobChip.click();

    // Save habit
    await alicePage.click('button:has-text("Save"), button:has-text("Create")');

    // Wait for it to appear on home
    await expect(alicePage.locator(`text=${HABIT_NAME}`).first()).toBeVisible();
  });

  test('Bob accepts habit invitation', async () => {
    // Bob might need to wait for background sync or go to home
    await bobPage.click('text="Home"');

    // Wait for the invitation banner
    const inviteBanner = bobPage.locator(`text=${ALICE_USERNAME} invited you to ${HABIT_NAME}`);
    await expect(inviteBanner).toBeVisible({ timeout: 15000 });

    // Accept it
    await bobPage.click('button:has-text("Accept")');

    // The shared habit should now be visible on Bob's home
    await expect(bobPage.locator(`text=${HABIT_NAME}`).first()).toBeVisible();
  });

  test('Alice and Bob send nudges', async () => {
    // Alice nudges Bob
    const aliceHabitCard = alicePage.locator(`text=${HABIT_NAME}`).locator('..');
    await aliceHabitCard.locator('button[aria-label="Nudge"]').click();

    // Bob receives nudge
    await bobPage.click('text="Social"');
    await bobPage.click('text="Activity"');
    await expect(bobPage.locator(`text="Nudged by ${ALICE_USERNAME}"`).first()).toBeVisible({ timeout: 15000 });
  });

  test('Mutual completion updates score', async () => {
    // Alice completes
    await alicePage.click('text="Home"');
    const aliceMudBtn = alicePage.locator(`text=${HABIT_NAME}`).locator('..').locator('button[aria-label="Complete Habit"]');
    
    // Assuming we need to long-press the Mud button
    const aliceBtnBox = await aliceMudBtn.boundingBox();
    if (aliceBtnBox) {
      await alicePage.mouse.move(aliceBtnBox.x + aliceBtnBox.width / 2, aliceBtnBox.y + aliceBtnBox.height / 2);
      await alicePage.mouse.down();
      // Hold for 2 seconds (Mud button requires sustained hold)
      await alicePage.waitForTimeout(2000);
      await alicePage.mouse.up();
    }

    // Verify Alice's card updates to completed
    await expect(alicePage.locator(`text=${HABIT_NAME}`).locator('..').locator('text="Completed"')).toBeVisible();

    // Bob completes
    await bobPage.click('text="Home"');
    const bobMudBtn = bobPage.locator(`text=${HABIT_NAME}`).locator('..').locator('button[aria-label="Complete Habit"]');
    
    const bobBtnBox = await bobMudBtn.boundingBox();
    if (bobBtnBox) {
      await bobPage.mouse.move(bobBtnBox.x + bobBtnBox.width / 2, bobBtnBox.y + bobBtnBox.height / 2);
      await bobPage.mouse.down();
      await bobPage.waitForTimeout(2000);
      await bobPage.mouse.up();
    }

    await expect(bobPage.locator(`text=${HABIT_NAME}`).locator('..').locator('text="Completed"')).toBeVisible();

    // Leaderboard validation
    await alicePage.click('text="Social"');
    await alicePage.click('text="Leaderboard"');
    
    await bobPage.click('text="Social"');
    await bobPage.click('text="Leaderboard"');

    // Both should have some incremented score (e.g., >0). The exact points depend on scoring logic.
    // For now, we just verify the names appear with a score greater than 0
    const aliceScoreStr = await alicePage.locator(`text=${ALICE_USERNAME}`).locator('xpath=following-sibling::*').first().innerText();
    const bobScoreStr = await bobPage.locator(`text=${BOB_USERNAME}`).locator('xpath=following-sibling::*').first().innerText();
    
    const aliceScore = parseInt(aliceScoreStr.replace(/[^0-9]/g, ''));
    const bobScore = parseInt(bobScoreStr.replace(/[^0-9]/g, ''));
    
    expect(aliceScore).toBeGreaterThan(0);
    expect(bobScore).toBeGreaterThan(0);
  });
});
