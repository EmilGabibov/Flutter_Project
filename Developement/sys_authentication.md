# 06 - Authentication System and Session Management

This document outlines the authentication and user session architecture within the Hable app. It covers the hybrid online-offline session state, the Riverpod state management implementation, Cloudflare backend routes, and the security model.

## 1. Overview and Hybrid Session Model

Hable uses a hybrid authentication model to support its offline-first architecture:
- **Online (Cloudflare Backend):** Relies on standard JSON Web Tokens (JWT) stored securely on the device. All authenticated API requests require a `Bearer <token>` header.
- **Offline (Drift Local Database):** Upon successful login, the backend responds with the user's profile which is cached in the local SQLite database (`Users` table). The app boots offline by reading the saved JWT and matching `userId`.

## 2. State Management (Riverpod)

Authentication state is managed globally by the `authProvider` (`NotifierProvider<AuthNotifier, AuthState>`).

### `AuthState` Properties
- `isLoading`: Boolean flag indicating active network requests (e.g., login, register, PIN requests).
- `isInitialized`: Boolean flag set to `true` once the app has attempted to load a saved session from secure storage on startup. Used to gate the splash screen.
- `isAuthenticated`: A derived boolean getter (`token != null && userId != null`).
- `error`: Stores user-friendly error messages parsed from backend or network exceptions.
- `token`, `userId`, `username`: Core session identifiers stored in memory.

### Session Lifecycle Hooks
- **Startup (`build()` & `_loadStoredAuth`):** Reads the JWT and `userId` from `flutter_secure_storage`. If found, it populates `AuthState` and asynchronously triggers the restoration of local reminders via `localReminderServiceProvider`.
- **Logout:** Clears all keys from secure storage, cancels pending local reminders, and resets the `AuthState`.

## 3. Local Persistence and Security

### `flutter_secure_storage`
The following keys are stored securely on the host device (Keychain on iOS/macOS, EncryptedSharedPreferences on Android):
- `jwt_token`: The Bearer token.
- `user_id`: The canonical UUID.
- `username`: The user's handle.

### Drift Database (`Users` Table)
The local database acts as the offline source of truth. The `_ensureUserInDb` method handles upserting the user profile when they log in or register.
Fields cached locally include `userId`, `username`, `email`, `avatarUrl`, and `emailVerifiedAt`.

## 4. Cloudflare Backend Routes

The backend provides a REST API for auth actions:
- **`POST /api/auth/login`**: Accepts `username` and `password` (or just `user_id` in test harnesses). Returns the JWT and full profile data.
- **`POST /api/auth/register`**: Accepts `username` and `password`. Creates a new account and returns the JWT.
- **`POST /api/auth/request-pin`**: Requests a password reset PIN via email (unauthenticated).
- **`POST /api/auth/reset-password`**: Commits a password reset with email, PIN, and new password (unauthenticated).

### Email Verification and Sync Activation
To participate in social/cloud sync features, users must verify their email. This requires an active JWT:
- **`POST /api/user/email/request-pin`**: Sends an OTP to the user's email. (Requires `Bearer` token).
- **`POST /api/user/email/verify-pin`**: Validates the OTP. On success, it updates the local Drift `emailVerifiedAt` timestamp to unlock sync features.

### Email Delivery Configuration
- `PRIVATE_EMAIL_SENDER_HABLE`: Verified sender address used by Hable's email flow.
- `CLOUDFLARE_ACCOUNT_ID`: Cloudflare account ID for the email-sending API.
- `PRIVATE_CLOUDFLARE_EMAIL_API_TOKEN`: API token with permission to send email for the Hable account.
- `EMAIL_WORKER`: Optional Cloudflare service binding for PIN delivery without duplicating sender/API-token secrets.
- To push the current Doppler values into the Hable Pages project, run `cd /Flutter/hable/backend && npm run sync:pages-secrets`.

## 5. Error Handling and Normalization

The `AuthNotifier` intercepts exceptions and normalizes them into user-friendly UI strings in `state.error`:
- **Network Failures:** Intercepts browser fetch/CORS failures, native socket failures, and timeouts, then maps them to one calm retry-oriented message family rather than exposing platform-specific exception text.
- **Backend Errors:** Extracts the structured `error.code` / `error.message` envelope where available, while still remaining compatible with legacy `{ error: '...' }` responses during migration.

Auth must not display raw exception text, backend URLs, stack traces, or raw response bodies in visible UI. Shared standards for error envelope shape, tone, and safe display are defined in [`sys_error_handling.md`](sys_error_handling.md).
