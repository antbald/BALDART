# UI Guidelines (Template)

This is a template for documenting your project's UI/UX guidelines. Customize this file for your project.

## Brand Identity

### Colors

**Primary Palette**:
- Primary: `#[color]` - [When to use]
- Secondary: `#[color]` - [When to use]
- Accent: `#[color]` - [When to use]

**Neutral Palette**:
- Black: `#000000`
- White: `#FFFFFF`
- Gray scale: [Define your grays]

**Semantic Colors**:
- Success: `#[color]`
- Warning: `#[color]`
- Error: `#[color]`
- Info: `#[color]`

### Typography

**Font Families**:
- Headings: `[Font name]`
- Body: `[Font name]`
- Monospace: `[Font name]`

**Type Scale**:
- H1: `[size]` / `[line-height]` / `[weight]`
- H2: `[size]` / `[line-height]` / `[weight]`
- H3: `[size]` / `[line-height]` / `[weight]`
- H4: `[size]` / `[line-height]` / `[weight]`
- Body: `[size]` / `[line-height]` / `[weight]`
- Small: `[size]` / `[line-height]` / `[weight]`

### Spacing

**Spacing Scale**:
- xs: `[value]`
- sm: `[value]`
- md: `[value]`
- lg: `[value]`
- xl: `[value]`
- 2xl: `[value]`

## Component Patterns

### Buttons

**Primary Button**:
- Background: [color]
- Text: [color]
- Hover: [behavior]
- Disabled: [state]

**Secondary Button**:
- Background: [color]
- Text: [color]
- Hover: [behavior]
- Disabled: [state]

### Forms

**Input Fields**:
- Border: [style]
- Focus: [state]
- Error: [state]
- Disabled: [state]

**Labels**:
- Position: [above/inline/floating]
- Required indicator: [style]

### Cards

**Card Structure**:
- Border: [style]
- Shadow: [value]
- Padding: [value]
- Border radius: [value]

## Layout

### Grid System

- Columns: [number]
- Gutter: [value]
- Container max-width: [value]

### Breakpoints

- Mobile: `< [value]`
- Tablet: `[value] - [value]`
- Desktop: `> [value]`

### Responsive Design

- Mobile-first approach
- Touch target minimum: 44x44px
- Readable line length: 50-75 characters

## Accessibility

### Color Contrast

- Text on background: minimum 4.5:1
- Large text: minimum 3:1
- UI components: minimum 3:1

### Keyboard Navigation

- All interactive elements keyboard accessible
- Visible focus indicators
- Logical tab order

### Screen Readers

- Semantic HTML
- ARIA labels where needed
- Alt text for images
- Form labels proper

## Animation

### Motion Principles

- Duration: [fast/medium/slow values]
- Easing: [easing functions]
- Purpose: [enhance UX, don't distract]

### Common Animations

- Page transitions: [description]
- Hover states: [description]
- Loading states: [description]
- Error states: [description]

## Design Tokens

Document your design tokens (if using):

```json
{
  "color": {
    "primary": "[value]",
    "secondary": "[value]"
  },
  "spacing": {
    "sm": "[value]",
    "md": "[value]"
  }
}
```

## Component Library

Link to your component library or design system:

- [Figma/Sketch file]
- [Storybook URL]
- [Component documentation]

## Examples

### Good Examples

[Screenshots or code examples of well-implemented UI]

### Anti-Patterns

[Examples of what to avoid]

## Resources

- [Design system documentation]
- [Brand guidelines]
- [Component library]
- [Accessibility guidelines]
