Based on the AltStore PAL documentation (including **Distribute with AltStore PAL**, **Make a Source**, **App Guidelines**, **Updating Apps**, and related developer pages), here's a practical end-to-end checklist you can use for **every app release**.

---

# ✅ Phase 1 — Apple Developer Account

## Apple Developer

* [ ] Paid Apple Developer Program membership
* [ ] App already created in App Store Connect
* [ ] Bundle Identifier finalized
* [ ] App ID created
* [ ] Certificates
* [ ] Provisioning Profiles
* [ ] Archive builds successfully

---

## Alternative Distribution

If distributing in the **EU**, you must:

* [ ] Accept Apple's Alternative EU Terms Addendum

If distributing **only in Japan**, this step isn't required. ([faq.altstore.io][1])

---

# ✅ Phase 2 — Register with AltStore PAL

## Register Developer

* [ ] Get Developer ID from App Store Connect
* [ ] Register Developer ID through AltStore REST API
* [ ] Receive security token
* [ ] Open App Store Connect
* [ ] Users & Access
* [ ] Integrations
* [ ] Marketplace
* [ ] Add AltStore Marketplace
* [ ] Paste security token
* [ ] Enable automatic notifications (recommended)

This only has to be done once. ([faq.altstore.io][1])

---

# ✅ Phase 3 — Prepare the App

Before submission:

* [ ] Production build
* [ ] Increment Version
* [ ] Increment Build Number
* [ ] Release notes
* [ ] Final icon
* [ ] Screenshots
* [ ] Description
* [ ] Privacy policy
* [ ] Verify entitlements
* [ ] Verify signing

---

# ✅ Phase 4 — App Review / Notarization

Inside App Store Connect:

* [ ] Select App
* [ ] App Review
* [ ] Edit Review Type
* [ ] Select **Notarization**
* [ ] Save
* [ ] Submit

If you're also releasing through the App Store, notarization happens automatically after App Store approval. ([faq.altstore.io][1])

---

# ✅ Phase 5 — Wait for Approval

* [ ] Apple Notarization Approved
* [ ] Processing completed

---

# ✅ Phase 6 — Download ADP

After approval:

* [ ] Download Alternative Distribution Package (ADP) via AltStore REST API
* [ ] Verify package integrity

---

# ✅ Phase 7 — Host the ADP

On your server:

* [ ] Upload entire ADP directory
* [ ] Preserve folder hierarchy
* [ ] Do **NOT** rename files
* [ ] Do **NOT** modify `manifest.json`
* [ ] Do **NOT** reformat JSON
* [ ] Verify HTTPS works
* [ ] Verify URLs are public

Changing file hashes or the manifest will break installation. ([faq.altstore.io][1])

---

# ✅ Phase 8 — Create Source JSON

Create your AltStore source.

## Source Metadata

* [ ] Source name
* [ ] Subtitle (optional)
* [ ] Description
* [ ] Website
* [ ] Icon
* [ ] Header image

---

## App Metadata

* [ ] App name
* [ ] Bundle Identifier
* [ ] Marketplace ID
* [ ] Developer name
* [ ] Subtitle
* [ ] Description
* [ ] Screenshots
* [ ] App icon
* [ ] Tint color (optional)

---

## Version Metadata

* [ ] Version
* [ ] Build Version
* [ ] Marketing Version
* [ ] Release date
* [ ] Changelog
* [ ] Download URL
* [ ] File size

The `downloadURL` for PAL should point to the hosted ADP (specifically the `manifest.json` or the ADP root directory). ([faq.altstore.io][2])

---

# ✅ Phase 9 — Host Source JSON

* [ ] Upload Source JSON
* [ ] Verify HTTPS
* [ ] Test URL
* [ ] Validate JSON

---

# ✅ Phase 10 — Install Test

Before announcing:

* [ ] Add source to AltStore PAL
* [ ] App appears correctly
* [ ] Icon loads
* [ ] Screenshots load
* [ ] Description displays
* [ ] Install succeeds
* [ ] Launch succeeds
* [ ] Updates work

---

# ✅ Phase 11 — Make Discoverable (Optional)

To appear on Explore:

* [ ] Add `fediUsername`
* [ ] Federate source using REST API

This makes the source discoverable on AltStore's Explore website. ([faq.altstore.io][1])

---

# ✅ Phase 12 — Future Updates

For every update:

* [ ] Build new version
* [ ] Increment version/build
* [ ] Submit for notarization
* [ ] Download new ADP
* [ ] Upload ADP
* [ ] Add a new version entry at the **top** of the versions array in your Source JSON
* [ ] Upload updated Source JSON

AltStore determines updates from the first compatible version listed in the versions array, not by date. ([faq.altstore.io][3])

---

# ✅ App Guidelines Checklist

Before every release, ensure:

* [ ] Complies with Apple Notarization requirements
* [ ] Metadata accurately represents the app
* [ ] Screenshots match the app
* [ ] Legal compliance in supported regions
* [ ] All licenses and intellectual property rights are in place
* [ ] No harmful or deceptive behavior

([faq.altstore.io][4])

---

# 📋 Master Release Checklist

```text
□ Apple Developer Account
□ Accept Alternative Terms (EU only)
□ Register Developer with AltStore
□ Add Marketplace Integration
□ Enable Notifications
□ Build Release
□ Update Version
□ Update Build Number
□ Upload to App Store Connect
□ Submit for Notarization
□ Wait for Approval
□ Download ADP
□ Upload ADP
□ Create Source JSON
□ Upload Source JSON
□ Validate Source
□ Test Installation
□ Test Updates
□ (Optional) Federate Source
□ Publish Release
```

This workflow covers the complete lifecycle—from initial developer account setup through publishing, hosting, testing, and shipping updates—for distributing an app on AltStore PAL.

[1]: https://faq.altstore.io/developers/distribute-with-altstore-pal?utm_source=chatgpt.com "Distribute with AltStore PAL | AltStore"
[2]: https://faq.altstore.io/developers/make-a-source?utm_source=chatgpt.com "Make a Source | AltStore"
[3]: https://faq.altstore.io/developers/updating-apps?utm_source=chatgpt.com "Updating Apps | AltStore"
[4]: https://faq.altstore.io/developers/app-guidelines?utm_source=chatgpt.com "App Guidelines | AltStore"
