## Onboarding Slide Research & Adaptation Plan

Based on the Hable project specifications, I have researched and adapted the onboarding requirements to move away from generic "academic" terminology and align with the "Chill & Minimal" visual philosophy and the "Mud" physics model.

### At a Glance

  * **Visual Tone:** Pastel/Sage Green palette, generous negative space, and a humorous, direct mascot tone.
  * **Physics Integration:** Education on the "Mud" model (1500ms mandatory press) is central to the user's first experience.
  * **Data Strategy:** Deferred verification (email/PIN) allows for immediate app utility, requiring only username/password initially.

-----

### 1\. Visual & Branding Alignment

The onboarding slides must immediately establish the aesthetic and behavioral anchors of the app.

  * **Color Philosophy:** Use muted tones (pastels, sage greens, warm grays). Vibrant colors are strictly prohibited during onboarding; they are reserved for the "Completion Moment" later in the journey.
  * **Typography:** Clean, rounded sans-serif with generous line height. The goal is to prevent "dashboard fatigue" from the very first screen.
  * **Mascot Tone:** The Hable mascot should deliver copy that is **Encouraging, Humorous, and Direct**.

### 2\. Adapted Onboarding Sequence

Generic terms like "exams" or "courses" are replaced with Hable-specific mechanics.

| Slide Title               | Hable Adaptation (Project Specifics)                                                                                   | Technical/UX Requirement                                                                 |
| :------------------------ | :--------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------- |
| **01: The Welcome**       | "Every day is day one." Use a soft, encouraging illustration instead of a blank slate.                                 | Start with **username/password only** to minimize initial friction.                      |
| **02: The Mud Model**     | Introduce the **physics of habit formation**. Explain that habits start with resistance (Mud) but stabilize over time. | Mention the **1500ms mandatory press** for new habits to signify the effort of starting. |
| **03: Your First Commit** | "Commit & Sync." Users select from **standard habit presets** (e.g., 21-day challenges).                               | Custom habits must accept an integer day duration.                                       |
| **04: The Social Spark**  | Introduce "Habit Partners." Explain that you don't track alone; you **invite friends** to share the journey.           | Highlight that partner progress is visible via **habit-colored rings**.                  |
| **05: Gentle Reminders**  | "Mascot-driven nudges." Frame notifications as supportive "pings" rather than demands.                                 | Trigger a **"Soft-Ask" prompt** only when the user toggles a reminder ON.                |

### 3\. Critical "Invisible" Requirements

  * **Deferred Verification:** Do not ask for email or PIN during these slides. This belongs in nested Settings as an optional cloud-sync/recovery activation card.
  * **Zero-Friction Completion:** Ensure the slides emphasize that the "Skip" button has been removed from the main tracker. Habits are maintained by action or lost by expiration.
  * **Privacy Guard:** Acknowledge that while habits are social, **Journal Entries are 100% private** and never shared with partners.

### 4\. Technical Constraints for Implementation

  * **Skeleton States:** Use lightweight skeleton blocks rather than loading spinners if fetching presets during onboarding.
  * **Empty State Transition:** The final slide should transition into the Home screen's "Empty State," which provides structured cards with icons and concise guidance.
  * **State Isolation:** Ensure the "Mud" math (1500ms target) is handled by the `StateNotifier` and not calculated within the slide's build method.