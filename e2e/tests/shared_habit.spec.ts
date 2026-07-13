import { test, expect, BrowserContext, Page } from '@playwright/test';

const RUN_ID = Date.now();
const ALICE = `Alice_${RUN_ID}`;
const BOB = `Bob_${RUN_ID}`;
const CHARLIE = `Charlie_${RUN_ID}`;
const HABIT_NAME = `E2E Shared Habit ${RUN_ID}`;

class UserSession {
  constructor(
    readonly name: string,
    readonly context: BrowserContext,
    readonly page: Page,
  ) {}

  async gotoHome() {
    await this.page.goto('/');
    await expect(this.page.locator('text="Home"').first()).toBeVisible({
      timeout: 15000,
    });
  }

  async register() {
    await this.page.goto('/');
    const signUpSwitch = this.page.locator('text="Need an account? Sign up"');
    if (await signUpSwitch.isVisible()) {
      await signUpSwitch.click();
    }
    await this.page.fill('input[placeholder="Username"]', this.name);
    await this.page.fill('input[placeholder="Password"]', 'password123');
    await this.page.click('button:has-text("Sign Up")');
    await this.gotoHome();
  }

  async openSocial(subTab?: 'Friends' | 'Activity' | 'Leaderboard') {
    await this.page.click('text="Social"');
    if (subTab) {
      await this.page.click(`text="${subTab}"`);
    }
  }

  async sendFriendRequest(username: string) {
    await this.openSocial();
    await this.page.click('button[aria-label="Find Friends"], text="Find friends"');
    const search = this.page.locator('input[placeholder="Search username..."]');
    await search.fill(username);
    await search.press('Enter');
    await expect(this.page.locator(`text="${username}"`).first()).toBeVisible();
    await this.page
      .locator(`text="${username}"`)
      .locator('..')
      .locator('button:has-text("Add Friend"), button:has-text("Send Friend Request")')
      .first()
      .click();
  }

  async acceptFriendRequest(username: string) {
    await this.openSocial('Friends');
    await expect(this.page.locator(`text="${username}"`).first()).toBeVisible({
      timeout: 15000,
    });
    await this.page
      .locator(`text="${username}"`)
      .locator('..')
      .locator('button:has-text("Accept")')
      .first()
      .click();
  }

  async createSharedHabit(partnerUsername: string) {
    await this.page.click('text="Home"');
    await this.page.click('button[aria-label="Create a new habit"], text="Habit"');
    await this.page.fill('input[placeholder="Habit title"]', HABIT_NAME);
    await expect(this.page.locator(`text="${partnerUsername}"`).first()).toBeVisible();
    await this.page.locator(`text="${partnerUsername}"`).first().click();
    await this.page.click('button:has-text("Save"), button:has-text("Create")');
    await expect(this.page.locator(`text="${HABIT_NAME}"`).first()).toBeVisible();
  }

  async acceptHabitInvitation(fromUsername: string) {
    await this.page.click('text="Home"');
    await expect(
      this.page.locator(`text="${fromUsername}"`).locator('..').locator('text="Accept"').first(),
    ).toBeVisible({ timeout: 15000 });
    await this.page
      .locator(`text="${fromUsername}"`)
      .locator('..')
      .locator('button:has-text("Accept")')
      .first()
      .click();
    await expect(this.page.locator(`text="${HABIT_NAME}"`).first()).toBeVisible();
  }

  async sendHabitNudge() {
    const card = this.page.locator(`text="${HABIT_NAME}"`).first().locator('..');
    await card.locator('button[aria-label="Nudge"], text="Nudge"').first().click();
  }

  async verifyNudgeFrom(username: string) {
    await this.openSocial('Activity');
    await expect(
      this.page.locator(`text=/.*${username}.*/`).first(),
    ).toBeVisible({ timeout: 15000 });
  }

  async followHabitFromFriendProfile(friendUsername: string) {
    await this.openSocial('Friends');
    await this.page.locator(`text="${friendUsername}"`).first().click();
    await expect(this.page.locator('text="Follow"').first()).toBeVisible({
      timeout: 10000,
    });
    await this.page.locator('text="Follow"').first().click();
    await expect(this.page.locator('input[placeholder="Habit title"]')).toHaveValue(
      HABIT_NAME,
    );
  }
}

test.describe('Three-player social invite, nudge, and follow flows', () => {
  let aliceContext: BrowserContext;
  let bobContext: BrowserContext;
  let charlieContext: BrowserContext;
  let alice: UserSession;
  let bob: UserSession;
  let charlie: UserSession;

  test.beforeAll(async ({ browser }) => {
    aliceContext = await browser.newContext();
    bobContext = await browser.newContext();
    charlieContext = await browser.newContext();

    alice = new UserSession(ALICE, aliceContext, await aliceContext.newPage());
    bob = new UserSession(BOB, bobContext, await bobContext.newPage());
    charlie = new UserSession(CHARLIE, charlieContext, await charlieContext.newPage());
  });

  test.afterAll(async () => {
    await Promise.all([
      aliceContext.close(),
      bobContext.close(),
      charlieContext.close(),
    ]);
  });

  test('register three isolated users', async () => {
    await alice.register();
    await bob.register();
    await charlie.register();
  });

  test('alice can friend both bob and charlie', async () => {
    await alice.sendFriendRequest(BOB);
    await alice.sendFriendRequest(CHARLIE);
  });

  test('bob and charlie accept alice friendship', async () => {
    await bob.acceptFriendRequest(ALICE);
    await charlie.acceptFriendRequest(ALICE);
  });

  test('alice invites bob into a shared habit', async () => {
    await alice.createSharedHabit(BOB);
  });

  test('bob accepts the shared habit invitation', async () => {
    await bob.acceptHabitInvitation(ALICE);
  });

  test('alice can nudge bob and bob sees the activity entry', async () => {
    await alice.sendHabitNudge();
    await bob.verifyNudgeFrom(ALICE);
  });

  test('charlie can follow the habit from alice profile without partner rights', async () => {
    await charlie.followHabitFromFriendProfile(ALICE);
  });
});
