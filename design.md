# Design Guide

## Reference

UI/UX pattern inspired by **"Where is My Train"** app:
- Clean search screen with two dropdown/input fields
- Simple list-style results with status badges
- Timeline-style live tracking view (vertical line with stops, times, distances)

## Language

- **Bengali first**, English secondary (labels can show both, e.g. "খুঁজুন / Find")
- Keep text minimal — icons + short labels over long sentences

## Layout Principles

- Mobile-first, single column layout
- Large tap targets (min 44px height for buttons)
- Bottom-anchored primary actions where possible (easier thumb reach)
- Avoid clutter — one primary action per screen

## Color Palette (placeholder — adjust once branding decided)

| Use | Color |
|---|---|
| Primary (header, buttons) | Deep blue (#1a5fb4) or route-based accent |
| Success/Running status | Green (#2e7d32) |
| Warning/Delayed status | Orange (#f57c00) |
| Background | Light gray (#f5f5f5) |
| Text | Dark gray/black (#212121) |

## Typography

- System fonts preferred (fast load, no external font files needed)
- Bengali font fallback: ensure `font-family` includes a Bengali-supporting system font (e.g. Noto Sans Bengali as web-safe fallback)

## Components Needed

- Stop selector (dropdown or searchable list)
- Bus/route result card
- Status badge (Running / Delayed / Not Started)
- Map container with custom bus marker icon
- Stop timeline list item (time, distance, platform-equivalent info if any)

## Icons

- Bus icon for map marker
- Location pin for stops
- Simple line icons (no heavy icon library needed — inline SVG preferred for single-file HTML)
