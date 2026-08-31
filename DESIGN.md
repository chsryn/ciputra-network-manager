---
name: Nexus Multi-Level Interface
colors:
  surface: '#f8f9fb'
  surface-dim: '#d9dadc'
  surface-bright: '#f8f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f6'
  surface-container: '#edeef0'
  surface-container-high: '#e7e8ea'
  surface-container-highest: '#e1e2e4'
  on-surface: '#191c1e'
  on-surface-variant: '#464555'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f3'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4d44e3'
  primary: '#3525cd'
  on-primary: '#ffffff'
  primary-container: '#4f46e5'
  on-primary-container: '#dad7ff'
  inverse-primary: '#c3c0ff'
  secondary: '#006591'
  on-secondary: '#ffffff'
  secondary-container: '#39b8fd'
  on-secondary-container: '#004666'
  tertiary: '#7e3000'
  on-tertiary: '#ffffff'
  tertiary-container: '#a44100'
  on-tertiary-container: '#ffd2be'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c3c0ff'
  on-primary-fixed: '#0f0069'
  on-primary-fixed-variant: '#3323cc'
  secondary-fixed: '#c9e6ff'
  secondary-fixed-dim: '#89ceff'
  on-secondary-fixed: '#001e2f'
  on-secondary-fixed-variant: '#004c6e'
  tertiary-fixed: '#ffdbcc'
  tertiary-fixed-dim: '#ffb695'
  on-tertiary-fixed: '#351000'
  on-tertiary-fixed-variant: '#7b2f00'
  background: '#f8f9fb'
  on-background: '#191c1e'
  surface-variant: '#e1e2e4'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  headline-md-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-padding: 24px
  gutter: 16px
  stack-sm: 12px
  stack-md: 20px
  max-width: 1440px
---

## Brand & Style
The design system focuses on a **Corporate / Modern** aesthetic tailored for high-stakes network management. It prioritizes clarity, hierarchy, and executive-level data visualization to transform complex downline structures into actionable insights.

The style utilizes a mix of **Minimalism** for data density and **Soft Tactile** elements for interactivity. By employing generous whitespace and a clean surface-to-background ratio, the interface evokes a sense of professional reliability and growth. The emotional response is one of "organized ambition"—providing users with the confidence that their network is stable, scalable, and transparent.

## Colors
The color palette is anchored by a deep Indigo primary, representing stability and corporate authority. The background is maintained at a very light grey to provide a soft canvas for pure white surfaces, reducing eye strain during long tracking sessions.

**Rank Indicators:**
- **Silver:** A sophisticated slate grey for entry-tier achievements.
- **Gold:** A vibrant amber for established performers.
- **Platinum:** A royal purple for leadership tiers.
- **Diamond:** A brilliant sky blue for peak performance levels.

Status colors (success, error, warning) should remain standard but lean toward slightly higher saturation to match the vibrant rank badges.

## Typography
This design system uses **Hanken Grotesk** for all primary UI text. Its sharp, contemporary grotesque letterforms ensure high legibility in dense data tables and member directories. The typeface strikes a balance between approachable and strictly professional.

For technical metadata, such as `member_id` and `upline_id`, **JetBrains Mono** is utilized as a label font. This monospaced choice distinguishes system-generated IDs from human-readable names like `full_name`, aiding in quick scanning and data entry accuracy.

## Layout & Spacing
The system utilizes a **Fluid Grid** with fixed-width constraints for readability. On desktop, a 12-column grid is preferred with a maximum container width of 1440px to prevent excessive line lengths. 

- **Mobile:** Single column with 16px horizontal margins.
- **Tablet:** 8-column grid with 24px margins.
- **Desktop:** 12-column grid with 32px margins.

Vertical rhythm follows an 8px base unit. Cards and data sections should be separated by a minimum of 24px (`stack-md`) to ensure the UI feels airy and premium despite high information density.

## Elevation & Depth
Depth is created through **Ambient Shadows** on pure white surfaces. This creates a clear distinction between the system background and interactive "Surface" containers.

- **Level 0 (Background):** #F3F4F6, flat.
- **Level 1 (Cards):** #FFFFFF, shadow: `0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.03)`.
- **Level 2 (Hover/Active):** #FFFFFF, shadow: `0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05)`.

Avoid heavy borders or harsh outlines; use tonal contrast to define the structure.

## Shapes
The design system follows a "Soft-Geometric" philosophy. Main containers, such as profile cards and data tables, utilize a specific **15px (rounded-lg)** corner radius to feel modern and friendly. 

However, interactive small-scale elements—specifically rank badges, input fields, and tags—must use a **Pill-shaped (9999px)** radius. This distinction creates a clear visual hierarchy between "Content Containers" (15px) and "Interactive Elements" (Pill).

## Components

### Rank Badges
Badges are pill-shaped with a subtle 10% opacity background of their respective rank color, paired with a high-contrast 100% opacity text color of the same hue. Use bold weight for the label.

### Pill Inputs
Input fields must be pill-shaped with a 1px border of `#E2E8F0`. On focus, the border transitions to the primary Indigo color with a 3px soft outer glow. Icons (e.g., Search, Phone) should be placed on the leading edge.

### Member Cards
Cards display `full_name` as a headline and `member_id` as a mono-label. Use 15px rounding. Upline relationship should be visualized via a "Upline Tree" breadcrumb or a linked badge component.

### Action Buttons
Primary buttons use a solid Indigo background with white text. Secondary buttons use a white background with a ghost border. All buttons follow the pill-shaped radius consistent with the input fields.

### Status Indicators
For `rank_level` transitions, use an animated pulse on the badge to signify a recent promotion. List items should have a hover state that slightly increases the elevation (Level 2 shadow).