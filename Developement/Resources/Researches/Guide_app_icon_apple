# Apple App Icon Guidelines (Structured Design Guide)

## 1. Purpose

Your app icon is the visual identity of your app. It should:

* Communicate your app's purpose instantly.
* Be memorable and recognizable.
* Represent your brand consistently across Apple platforms.
* Remain clear at every size.

---

# 2. Core Principles

## Simplicity

Design around a single strong concept.

✅ Good

* One recognizable object
* Minimal shapes
* Clear silhouette

❌ Avoid

* Busy illustrations
* Tiny details
* Multiple unrelated objects

---

## Recognition

Someone should recognize your app from:

* Home Screen
* Spotlight
* Notifications
* Settings
* Share Sheets

without reading its name.

---

## Consistency

Use the same visual identity on:

* iOS
* iPadOS
* macOS
* watchOS
* visionOS
* tvOS

Adapt only the icon shape—not the concept.

---

# 3. Layered Design

Modern Apple icons are **layer-based**, not just flat images.

Typical structure:

```
Background

↓

Foreground Layer 1

↓

Foreground Layer 2

↓

Foreground Layer 3
```

Benefits:

* Depth
* Lighting
* Refraction
* Specular highlights
* Liquid Glass effects
* Parallax (tvOS)
* 3D expansion (visionOS)

---

## Background

Should be:

* Solid color
* Gradient
* Full bleed
* Opaque

Avoid:

* Complex textures
* Photos
* Partial backgrounds

---

## Foreground

Use:

* Clearly defined edges
* Filled shapes
* Transparency where appropriate

Avoid:

* Feathered edges
* Soft shadows
* Blurred artwork

---

# 4. Let the System Add Effects

Do **not** manually add:

* Drop shadows
* Highlights
* Glows
* Blur
* Bevel
* Reflections

Apple automatically applies:

* Liquid Glass
* Lighting
* Refraction
* Highlights
* Shadows

---

# 5. Icon Shape

Never round the corners yourself.

Provide the raw artwork.

The system masks it automatically.

| Platform | Canvas    | Final Shape       |
| -------- | --------- | ----------------- |
| iOS      | Square    | Rounded rectangle |
| iPadOS   | Square    | Rounded rectangle |
| macOS    | Square    | Rounded rectangle |
| tvOS     | Rectangle | Rounded rectangle |
| visionOS | Square    | Circle            |
| watchOS  | Square    | Circle            |

---

# 6. Center Important Content

Keep the primary subject centered.

Why?

The system crops corners.

Poor placement causes clipping.

Use Apple's production grids.

---

# 7. Prefer Filled Shapes

Apple strongly prefers:

✔ Filled shapes

instead of

✘ Thin outlines

Filled objects create better:

* depth
* lighting
* translucency
* readability

---

# 8. Avoid Photos

Don't use:

* Photos
* Screenshots
* UI mockups

Instead create:

* Illustrations
* Symbols
* Simplified graphics

---

# 9. Text Usage

Avoid text unless absolutely necessary.

Problems:

* Doesn't localize
* Too small
* Creates clutter

If needed:

* Use a single letter
* Brand initials only

Avoid words like:

* Play
* Watch
* New
* Pro
* VisionOS

---

# 10. Transparency

Transparency creates depth.

Example:

```
Layer 1
██████

Layer 2
░░████░░

Layer 3
████
```

Instead of everything being 100% opaque.

---

# 11. Vector First

Preferred formats:

* SVG
* PDF (vector)

Raster only when necessary:

* PNG

Avoid:

* JPEG

---

# 12. Design Philosophy

Your icon should communicate:

* personality
* function
* identity

using as few elements as possible.

---

# 13. Appearance Variants

For iOS, iPadOS, macOS support:

* Default
* Dark
* Clear Light
* Clear Dark
* Tinted Light
* Tinted Dark

Apple automatically generates missing variants, but providing custom versions gives better results.

---

## Rules

Keep:

* same symbol
* same composition
* same identity

Only adapt:

* colors
* lighting
* contrast

Never redesign the icon entirely.

---

# 14. Alternate Icons

Optional.

Good examples:

* Sports teams
* Seasonal themes
* Brand variations

They should still be unmistakably your app.

---

# 15. Platform Notes

## tvOS

Supports:

* 2–5 layers
* Parallax animation

Keep content inside a safe zone.

---

## visionOS

Supports:

* Background
* 1–2 foreground layers

Avoid fake holes or concave shapes.

---

## watchOS

Avoid pure black backgrounds.

They blend into the watch bezel.

---

# 16. Technical Specifications

| Platform | Canvas Size | Style              |
| -------- | ----------- | ------------------ |
| iOS      | 1024×1024   | Layered            |
| iPadOS   | 1024×1024   | Layered            |
| macOS    | 1024×1024   | Layered            |
| visionOS | 1024×1024   | Layered (3D)       |
| watchOS  | 1088×1088   | Layered            |
| tvOS     | 800×480     | Layered + Parallax |

---

# 17. Color Spaces

Supported:

* sRGB
* Display P3
* Gray Gamma 2.2

---

# 18. Common Mistakes

❌ Rounded corners in artwork

❌ Drop shadows

❌ Outer glows

❌ Bevel effects

❌ Tiny details

❌ Photos

❌ UI screenshots

❌ Apple hardware

❌ Busy backgrounds

❌ Thin outlines

❌ Too many objects

❌ Excessive text

---

# 19. Design Checklist

Before exporting, verify:

* [ ] One clear visual concept
* [ ] Simple silhouette
* [ ] Background is clean
* [ ] Filled foreground shapes
* [ ] No manual shadows
* [ ] No manual highlights
* [ ] No rounded corners
* [ ] Centered composition
* [ ] Vector artwork when possible
* [ ] Consistent across platforms
* [ ] Looks good at small sizes
* [ ] Supports dark/tinted variants
* [ ] Uses transparency intentionally
* [ ] No photos or screenshots
* [ ] Brand remains recognizable in every appearance