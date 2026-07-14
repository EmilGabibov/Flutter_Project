# QA Accessibility Guidelines

## Keyboard Navigation

To ensure keyboard users and power users can navigate efficiently, the following standards apply across the app:

### Context Menus (`HableContextMenu`)
The unified context menu system implements the following keyboard interactions:
- **Arrows walk:** Users can navigate linearly through the menu list using the Up/Down arrow keys.
- **Type-ahead (Letters jump):** Pressing a specific letter key instantly jumps focus to the first corresponding action in the menu.
- **Esc closes one level:** Pressing the `Escape` key dismisses only the active submenu or the context menu, returning focus securely back to the trigger element without dismissing the entire UI stack.

## Platform Context
- **Desktop/Web:** Context menus open as traditional dropdowns anchored to the interaction point (right-click or pointer click).
- **Mobile (iOS/Android):** Context menus adapt natively to bottom sheets triggered by long-presses, providing a touch-friendly target space.

## Screen Reader Semantics
- Menu items use explicit `intent` labels. Destructive actions must be clearly communicated.
- Collapsed stacks (like habit partners) should announce the total count of items.
