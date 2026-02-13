# Design Review

## Purpose

Define design review process and UI/UX quality standards.

## Scope

**In**: UI review criteria, design consistency, accessibility.
**Out**: Implementation details (see agents/coding-standards.md).

## Do

- Review designs before implementation
- Check accessibility
- Ensure consistency with design system
- Test across devices/browsers

## Do Not

- Skip design review for "small" changes
- Ignore accessibility requirements
- Assume designs work on all screen sizes

## Design Review Checklist

### Visual Design

- [ ] Follows design system/style guide
- [ ] Consistent spacing and alignment
- [ ] Appropriate typography
- [ ] Color contrast meets WCAG standards
- [ ] Icons and imagery appropriate
- [ ] Loading states designed
- [ ] Error states designed
- [ ] Empty states designed

### Layout

- [ ] Responsive across breakpoints
- [ ] Mobile-first approach
- [ ] Proper use of grid/flexbox
- [ ] No horizontal scroll on mobile
- [ ] Touch targets minimum 44x44px
- [ ] Content hierarchy clear

### Interaction Design

- [ ] Clear call-to-actions
- [ ] Feedback for user actions
- [ ] Loading indicators where needed
- [ ] Error messages helpful
- [ ] Forms easy to complete
- [ ] Navigation intuitive

### Accessibility (WCAG 2.1 AA)

- [ ] Color contrast ≥ 4.5:1 (text)
- [ ] Color contrast ≥ 3:1 (UI components)
- [ ] Keyboard navigation works
- [ ] Focus indicators visible
- [ ] Alt text for images
- [ ] ARIA labels where needed
- [ ] Form labels proper
- [ ] Screen reader friendly

### Performance

- [ ] Images optimized
- [ ] Fonts optimized
- [ ] Animations performant
- [ ] No layout shift
- [ ] Fast loading

### Content

- [ ] Copy clear and concise
- [ ] Tone consistent with brand
- [ ] No jargon (unless necessary)
- [ ] Error messages helpful
- [ ] Microcopy thoughtful

## Review Process

### 1. Pre-Implementation Review

- Review designs/mockups
- Clarify requirements
- Identify technical constraints
- Estimate effort

### 2. Implementation Review

- Build matches design
- Interactions work as specified
- Edge cases handled

### 3. Final Review

- Test on multiple devices
- Test on multiple browsers
- Accessibility check
- Performance check

## Common Issues

### Layout Issues

- Inconsistent spacing
- Misaligned elements
- Broken responsive behavior
- Text overflow

### Interaction Issues

- Missing feedback
- Confusing navigation
- Unclear error messages
- Slow interactions

### Accessibility Issues

- Low color contrast
- Missing alt text
- No keyboard navigation
- Poor focus indicators
- Missing ARIA labels

## Review Tools

- **Design**: [e.g., Figma, Sketch, Adobe XD]
- **Accessibility**: [e.g., axe DevTools, WAVE, Lighthouse]
- **Responsive**: [e.g., Browser DevTools, BrowserStack]
- **Performance**: [e.g., Lighthouse, WebPageTest]

## Design System

Reference your design system:

- **Components**: [Link to component library]
- **Colors**: [Link to color palette]
- **Typography**: [Link to typography scale]
- **Spacing**: [Link to spacing system]
- **Icons**: [Link to icon set]

## Browser Support

Define supported browsers:

| Browser | Minimum Version |
|---------|----------------|
| Chrome | [version] |
| Firefox | [version] |
| Safari | [version] |
| Edge | [version] |
| Mobile Safari | [version] |
| Mobile Chrome | [version] |

## Device Support

Define supported devices:

- **Desktop**: [min resolution]
- **Tablet**: [resolution range]
- **Mobile**: [resolution range]

## Review Outcomes

- **Approved**: Ready for implementation/deployment
- **Approved with minor changes**: Small tweaks needed
- **Needs revision**: Significant changes required
- **Rejected**: Fundamental issues, needs redesign
