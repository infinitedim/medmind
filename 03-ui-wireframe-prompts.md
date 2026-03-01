# MedMind — UI/UX & Wireframe Generation Prompts

> Gunakan prompt-prompt di bawah ini untuk generate wireframe dan UI/UX design menggunakan tools seperti v0.dev, Cursor AI, Claude, ChatGPT, Midjourney, atau Figma AI.
>
> **Design Philosophy:**
> - Referensi: shadcn/ui, Linear, Vercel Dashboard, Notion
> - Style: Clean, minimal, data-dense tapi tidak overwhelming
> - Typography: Inter / Geist font family
> - Color: Neutral grays sebagai base, satu accent color (zinc + teal/indigo)
> - Radius: Consistent 8px–12px border radius
> - Spacing: 4px grid system
> - Dark mode first

---

## MASTER DESIGN SYSTEM PROMPT

Gunakan prompt ini sebelum generate screen manapun agar konsisten.

```
Design a mobile health tracking app called "MedMind" using a modern, minimal design system inspired by shadcn/ui and Linear app.

Design System Rules:
- Color palette: Dark background (#09090B zinc-950), Card surface (#18181B zinc-900), Border (#27272A zinc-800), Muted text (#71717A zinc-500), Primary text (#FAFAFA zinc-50), Accent: Teal (#14B8A6 teal-500) for positive/health indicators, Destructive: (#EF4444 red-500) for alerts
- Typography: Inter font. Display: 32px/700, H1: 24px/600, H2: 18px/600, Body: 14px/400, Caption: 12px/400, Mono: JetBrains Mono for numbers/data
- Spacing: 4px base unit. Use 8, 12, 16, 20, 24, 32, 40, 48px consistently
- Border radius: 8px for cards, 6px for inputs/buttons, 4px for badges/chips, 999px for pills
- Shadows: Subtle, dark-mode optimized. Use border instead of heavy shadow
- Components (shadcn/ui style): Card with border + subtle background, Button variants (default/outline/ghost/destructive), Badge/Chip with dot indicator, Input with floating label, Separator/Divider thin zinc-800
- Icons: Lucide icons (stroke, 16px/20px)
- Mobile: 390px width (iPhone 15 Pro), safe area insets, bottom navigation 72px height
- Animation: Subtle, purposeful. 200ms ease-out for micro interactions, 400ms for page transitions
```

---

## SCREEN 1: ONBOARDING FLOW

### 1A. Welcome Screen

```
Using the MedMind design system above, create a mobile onboarding welcome screen.

Layout:
- Full screen dark background (#09090B)
- Center: Large minimalist icon/logo — a stylized brain or EKG pulse line in teal (#14B8A6), ~80px
- Below icon: App name "MedMind" in 32px/700 white
- Tagline: "Track symptoms. Discover patterns. Own your health data." in 16px/400 zinc-400, centered, max 260px width
- Below tagline: Small horizontal row of 3 feature pills ("On-device AI", "100% Private", "Offline-first") — each pill: zinc-900 bg, zinc-700 border, 12px text zinc-300, with relevant Lucide icon (Brain, Shield, WifiOff)
- Bottom: Primary CTA button "Get Started" — full width minus 32px padding, teal background, white text, 48px height
- Secondary: "Already have data? Import backup" ghost button below CTA, zinc-400 text
- Very bottom: "Your data never leaves your device." with Shield icon, 12px zinc-500

Style notes:
- Subtle radial gradient from teal-950/20 at center fading to transparent
- Logo has subtle glow: box-shadow 0 0 40px teal-500/30
- Staggered fade-in animation for each element
```

### 1B. Symptom Setup Screen

```
Using the MedMind design system, create a symptom selection onboarding screen.

Layout:
- Status bar area + back arrow (ghost) top left, "2 of 4" step indicator top right (pills, teal active)
- H1: "What would you like to track?" 24px/600 white
- Subtitle: "Select symptoms to monitor. You can change this later." zinc-400 14px
- Search input below: zinc-900 bg, zinc-800 border, search icon left, "Search symptoms..." placeholder
- Category filter chips below search: horizontal scroll — "All" (active/teal), "Neurological", "Digestive", "Respiratory", "Musculoskeletal", "Mental Health" — inactive: zinc-800 bg, zinc-600 text
- Symptom grid: 2 columns, each card 8px radius, zinc-900 bg, zinc-800 border. Card content: emoji icon + symptom name (14px/500) + category badge (12px pill). Selected state: teal-500/20 bg, teal-500 border, teal checkmark top-right corner
- Pre-selected common symptoms: Headache, Fatigue, Anxiety, Nausea, Back Pain, Sleep Issues
- Bottom: Fixed footer — "X selected" zinc-400 text left, "Continue" primary button right (disabled state: zinc-700 bg, cursor-not-allowed if 0 selected)

Style notes:
- Grid cards animate in with staggered slide-up + fade
- Selection tap: short scale animation (0.95 → 1.0)
```

### 1C. Security Setup Screen

```
Using the MedMind design system, create a biometric security setup screen.

Layout:
- "4 of 4" step indicator
- H1: "Protect your data" white 24px/600
- Subtitle: "MedMind uses end-to-end encryption. Add biometric lock for extra security." zinc-400 14px
- Center illustration: Phone with fingerprint/face icon, teal accent, minimal line art style
- Two option cards (full width, zinc-900 bg, zinc-800 border, 12px radius):
  Card 1 — "Enable Biometric Lock" — with Fingerprint icon (teal), "Unlock with fingerprint or face ID" subtitle zinc-400, toggle switch right (teal when on)
  Card 2 — "Auto-lock after" — with Timer icon (zinc-400), dropdown showing "5 minutes" — only visible/active if biometric enabled
- Info box below cards: zinc-900 bg, zinc-800 border-l-2 teal-500, text: "Your encryption key is stored in Android Keystore, a hardware-secured chip. MedMind cannot access your data without your biometric." 12px zinc-400
- Bottom: "Set Up Later" ghost button + "Finish Setup" primary button
```

---

## SCREEN 2: HOME / DASHBOARD

### 2A. Home Page — Main Dashboard

```
Using the MedMind design system, create the main home dashboard screen for a health journaling app.

Layout (scrollable, bottom nav visible):
- Top bar: "Good evening, [name]" left (18px/600 white), notification bell icon right (badge dot if unread), settings gear icon right
- Date: "Monday, March 2" zinc-400 14px below greeting

SECTION: Today's Summary Card
- Full-width card, zinc-900 bg, zinc-800 border, 12px radius
- Card header: "Today's Health" label zinc-400 12px/500 uppercase tracking-wider, "Log Entry" ghost button with Plus icon right
- Health score ring: 80px ring (CustomPaint style), animated, teal gradient arc, number "78" center 24px/700 white, "Score" 10px zinc-500 below, trend arrow + "↑ 4 from yesterday" teal 12px
- Below ring: 3 stat chips in a row:
  "7h 20m" with Moon icon zinc-400 (sleep)
  "3/10" with Activity icon zinc-400 (symptoms logged)
  "😊 Good" (mood)
- Bottom of card: subtle zinc-800 border-top, "Last logged: Today, 9:32 PM" zinc-500 12px

SECTION: Streak & Quick Actions
- "🔥 7-day streak" — zinc-900 card, flame emoji, "Keep it going!" zinc-400 12px
- Quick log row: 3 ghost cards side by side: "Log Mood" (Smile icon), "Log Symptom" (Plus icon), "Add Note" (FileText icon) — zinc-900 bg, zinc-800 border, icon teal, label 12px zinc-300

SECTION: Recent Insights (2 cards horizontal scroll)
- Section header: "Latest Insights" H2 18px/600, "See all →" teal 14px right
- Insight card (horizontal scroll): 280px wide, zinc-900 bg, zinc-800 border. Top: InsightType badge ("Correlation", teal pill). Title: "Sleep & Migraine Link" 14px/600 white. Body: "You're 2.8× more likely to have a migraine after < 6hrs sleep." 13px zinc-400. Bottom: confidence bar (teal filled) + "87% confidence" 12px zinc-500

SECTION: This Week (mini calendar strip)
- 7 day circles (Mon–Sun), today highlighted teal, past days with mood dot, future greyed
- Below each: small symptom count badge

Bottom Navigation (72px, zinc-950 bg, zinc-800 border-top):
4 items: Home (active teal), Journal, Insights, Settings
Active: icon teal + label teal 10px, Inactive: icon zinc-500 + label zinc-500 10px
```

---

## SCREEN 3: JOURNAL

### 3A. Journal List Page

```
Using the MedMind design system, create a journal entries list page.

Layout:
- Top bar: "Journal" H1 24px/600 white left, search icon + filter icon right (zinc-400)
- Below: Tab filter row — "All", "This Week", "This Month", "Drafts" — pill tabs, teal active underline style
- Search bar (collapsible, appears when search icon tapped): zinc-900 bg, zinc-800 border, full width, X to close

JOURNAL ENTRY CARDS (vertically stacked, 8px gap):
Each card — zinc-900 bg, zinc-800 border, 12px radius, 16px padding

Card anatomy:
- Top row: Date "Mon, Mar 2" zinc-300 12px/500, status badge right ("Complete" zinc-700/zinc-300 or "Draft" amber-900/amber-300)
- Mood row: Large emoji (😊/🙂/😐/😟/😰) + mood label + intensity bar (10 segments, teal fill) + "8/10" number
- Symptoms row: Horizontal chip list — each chip: 6px radius, zinc-800 bg, zinc-600 border, "Headache • 7" text 12px zinc-300. If > 3 chips, "+2 more" overflow chip
- Sleep row: Moon icon zinc-400 + "7h 30m" + quality indicator 3 filled dots
- Snippet row: Italic excerpt from free text, zinc-400 13px, max 2 lines, ellipsis
- Bottom row: "Caffeine • Alcohol • No Exercise" lifestyle tags zinc-500 11px + edit ghost icon far right

Empty state (no entries):
- Center illustration: minimal notebook line art, teal accent
- "No entries yet" white 18px/600
- "Start by logging how you're feeling today." zinc-400 14px
- "Create First Entry" teal button

FAB (if no current-day entry): Floating "+" button bottom-right, teal bg, white icon, 56px
```

### 3B. Journal Entry Form — Mood & Symptoms Tab

```
Using the MedMind design system, create a journal entry form page, Tab 1: Mood & Symptoms.

Header:
- Back arrow left, "New Entry" H1 center or "Mon, Mar 2" subtitle, "Save Draft" ghost right, "Save" primary button right (disabled until min 1 field filled)
- Tab bar below header: "Mood & Symptoms" (active), "Sleep & Meds", "Lifestyle & Notes" — zinc-800 underline style, active teal

MOOD SECTION:
- Label: "How are you feeling?" zinc-400 12px/500 uppercase
- 5 mood buttons in a horizontal row, equal width:
  😰 Terrible | 😟 Bad | 😐 Okay | 🙂 Good | 😊 Great
  Each: zinc-900 bg, zinc-800 border, selected: teal-500/20 bg teal border, emoji 24px, label 11px
- Intensity slider (shows after mood selected):
  Label: "Intensity" + value "8/10" right
  Custom slider: teal thumb, teal fill, 6px track height, rounded

SYMPTOMS SECTION:
- Section label: "Symptoms Today" zinc-400 12px/500 uppercase + "+ Add" ghost button right
- Symptom chips (logged): each chip is an expandable card
  Collapsed: symptom name + severity badge (colored by severity: green 1-3, yellow 4-6, orange 7-8, red 9-10) + chevron-down icon
  Expanded (tap to expand): shows severity slider + optional notes input + remove button
  Animation: smooth expand/collapse 300ms
- "No symptoms today looks good! 💪" empty state zinc-500 italic when nothing logged
- Symptom selector sheet (bottom sheet, appears on "+ Add" tap):
  Search input at top
  Category filter chips
  Symptom grid (same as onboarding)
  "Add Selected (X)" button

Style notes:
- Form has subtle background: zinc-950, cards inside use zinc-900
- Auto-save indicator: "Saving..." zinc-500 12px fades in/out top right
```

### 3C. Journal Entry Form — Sleep & Medications Tab

```
Using the MedMind design system, create journal form Tab 2: Sleep & Medications.

SLEEP SECTION:
- Section label: "Sleep Last Night" zinc-400 12px uppercase
- Two time pickers side by side:
  Left card: "Bedtime" label zinc-400 12px, clock icon teal, "11:30 PM" 24px/600 white, tap to open time picker
  Right card: "Wake Time" label, "7:00 AM" 24px/600 white
- Duration pill below (auto-calculated): "7h 30m" in teal pill, Moon icon left
- Health Connect sync row: HealthConnect logo small + "Import from Health Connect" zinc-300 14px + sync icon right. Subtle zinc-800 bg card, tap to import
- Sleep Quality slider: "Quality" label + "8/10" right, same teal slider style
- Disturbances stepper: "Woke up" label + minus button / "2 times" / plus button — zinc-900 cards for buttons, zinc-300 value

MEDICATIONS SECTION:
- Section label: "Medications" zinc-400 12px uppercase + "Manage" zinc-400 ghost right
- Medication list (from user profile):
  Each row: pill emoji or Pill icon + med name 14px/500 white + dosage zinc-400 12px + toggle switch far right (green when taken, zinc-700 when not)
  Expanded state (tap row): time taken picker + dosage override input
- "No medications set up. Add in Settings." empty state zinc-500 if list empty
- Bottom: "+ Log PRN medication" ghost button (as-needed meds)
```

### 3D. Journal Entry Form — Lifestyle & Notes Tab

```
Using the MedMind design system, create journal form Tab 3: Lifestyle & Notes.

LIFESTYLE FACTORS SECTION:
- Section label: "Lifestyle Today" zinc-400 12px uppercase

Three types of factor inputs:

Boolean factors (toggle row):
- Row: factor name 14px white + emoji icon + toggle switch right
- e.g., "Caffeine ☕", "Alcohol 🍷", "Smoking 🚬", "Supplements 💊"

Numeric factors (input row):
- Row: factor name + quantity input field (centered, 48px wide, zinc-900 bg zinc-800 border) + unit label zinc-400
- e.g., "Water 💧 [  8  ] glasses", "Exercise 🏃 [ 30 ] minutes"

Scale factors (compact slider):
- Label + value right + mini slider (same teal style but compact, 4px track height)
- e.g., "Stress Level 😤: 6/10", "Energy Level ⚡: 7/10"

FREE TEXT SECTION:
- Section label: "Notes" zinc-400 12px uppercase + word count "0 words" zinc-500 right
- Large textarea: zinc-900 bg, zinc-800 border, 12px radius, min 120px height, auto-expand
- Placeholder: "How are you feeling? Any triggers or observations?" zinc-600 italic
- After save (if text entered): NLP suggestion banner appears at bottom:
  Amber-900/20 bg, amber-500 border-l-2, Sparkles icon amber, "We noticed you mentioned headache and fatigue. Add to symptoms?" with "Add" teal button + "Dismiss" ghost

ACTIVITY SECTION (compact, bottom):
- "Activity Level" label + 5 icon buttons horizontal:
  Sofa (Sedentary) | Walk (Light) | Bike (Moderate) | Run (Active) | Zap (Intense)
  Selected: teal bg + white icon, unselected: zinc-800 bg zinc-400 icon
```

---

## SCREEN 4: INSIGHTS

### 4A. Insights Overview Page

```
Using the MedMind design system, create an insights/analytics page for a health journaling app.

Layout:
- Header: "Insights" H1 24px/600, period selector right: "Last 30 days ▾" ghost button with Calendar icon

HEALTH SCORE SECTION (prominent, top):
- Large card zinc-900 bg:
  Center: AnimatedRing 120px — gradient arc teal-to-cyan, thick ring (~12px), "78" 36px/700 white center, "Health Score" 12px zinc-500 below
  Right side panel (vertical stack):
    "↑ 4" in teal with arrow-up icon, "vs last week" zinc-500 12px
    Three sub-scores:
      "Sleep 8.2" with color dot teal
      "Mood 6.5" with color dot cyan  
      "Symptoms 7.1" with color dot indigo
  Bottom of card: trend description "Improving steadily — sleep quality driving gains" zinc-400 13px italic

TAB BAR:
"Insights" | "Correlations" | "Timeline" — zinc-800 line style, teal active

--- TAB: INSIGHTS ---
"Not enough data" state (< 14 days):
- Vertical centered: info icon teal, "Build your baseline" 18px/600 white, "Journal for 14 days to unlock AI insights." zinc-400, Progress bar: "Day 9 of 14" with teal fill, "5 more days to go 🔑" zinc-400

Normal state:
INSIGHT CARDS (vertical list):
Each card zinc-900 bg zinc-800 border 12px radius:
- Top: Type badge pill left ("Correlation" teal / "Anomaly" amber / "Trend" indigo) + Confidence "87%" right zinc-500 12px
- Title: 16px/600 white e.g. "Sleep Duration → Migraine Risk"
- Body: 14px zinc-300 "You're 2.8× more likely to experience migraines after sleeping fewer than 6 hours. Observed across 23 instances."
- Supporting mini-chart: tiny sparkline or bar comparison inline (2 bars: "< 6hrs nights: 78% migraine" vs "> 6hrs nights: 12% migraine") teal/zinc colored
- Footer: "Based on 31 days of data" zinc-500 12px + Bookmark icon right (zinc-400, filled when saved)
- Expand chevron: tap card to expand with full description + recommended action bullet points

--- TAB: CORRELATIONS ---
Heatmap panel:
- Label: "Variable Correlation Matrix" zinc-400 12px + "?" help icon
- Interactive heatmap grid (scrollable if many variables):
  Cells: colored squares, teal=positive correlation, red=negative, white/gray=none
  Cell text: correlation coefficient "0.72" 10px mono
  Row/column labels: truncated variable names 10px zinc-400
  Selected cell: white ring outline, shows tooltip card: "Sleep Quality × Mood Score: r=0.72, p<0.01, 28 data points"

--- TAB: TIMELINE ---
Symptom timeline strip (horizontal scroll):
- Date axis top, 7 days visible, scroll for more, 44px per day
- Rows (collapsible): Sleep bar, Mood dot, Migraine intensity, Caffeine icon, Mood score
- Row labels left side 11px zinc-500, chevron to collapse
- Today marker: teal vertical dashed line
```

---

## SCREEN 5: SETTINGS

### 5A. Settings Page

```
Using the MedMind design system, create a settings page for a health tracking app.

Layout:
- Header: "Settings" H1 24px/600

PROFILE SECTION (card zinc-900):
- Avatar circle 48px (initials or placeholder) + "Your Name" 16px/600 white + "Edit Profile" zinc-400 14px right arrow

SETTINGS SECTIONS — each section: label zinc-400 12px uppercase tracking-wider, then list cards below

Section "Data & Privacy":
- Row: Shield icon zinc-400 | "Encryption Status" white 14px | "AES-256 Active" teal 12px right + chevron
- Row: Key icon | "Change Biometric Lock" | current status toggle
- Row: Database icon | "Health Connect Sync" | toggle
- Row: Download icon | "Export My Data" | "PDF or CSV" zinc-400 12px | chevron

Section "Tracking":
- Row: Activity icon | "Manage Symptoms" | "12 tracked" zinc-400 | chevron
- Row: Pill icon | "Manage Medications" | "3 tracked" zinc-400 | chevron
- Row: Zap icon | "Manage Lifestyle Factors" | "6 tracked" zinc-400 | chevron
- Row: Bell icon | "Reminders" | "Daily at 9:00 PM" zinc-400 | chevron

Section "Appearance":
- Row: Moon icon | "Theme" | segmented control: "System|Light|Dark" teal active
- Row: Globe icon | "Language" | "English" zinc-400 | chevron

Section "About":
- Row: Info icon | "Version" | "1.0.0 (42)" zinc-500 right
- Row: FileText icon | "Privacy Policy" | chevron
- Row: Trash-2 icon red | "Delete All Data" | destructive red 14px (no chevron, tap shows confirmation dialog)

DANGER ZONE CARD (zinc-900 bg, red-950/20 bg, red-800 border):
- "Delete All Data" title red 16px/600
- Body: "This permanently destroys your encryption key, making all data unrecoverable. This cannot be undone." zinc-400 13px
- "Delete Everything" button destructive (red bg white text), full width

Style notes:
- Section rows: no outer border per-row, just zinc-800 separator between rows
- Rows use HStack: icon (20px zinc-400) + flex-1 label + trailing element
- Hover/press: zinc-800/50 bg highlight
```

---

## SCREEN 6: ONBOARDING — ADDITIONAL

### 6A. Lifestyle Factors Setup

```
Using the MedMind design system, create a lifestyle factors onboarding screen (step 3 of 4).

Layout:
- Step indicator "3 of 4" top right
- H1: "Lifestyle factors to track" white 24px/600
- Subtitle: "What habits affect your health? Select to track daily." zinc-400 14px

PRE-GROUPED FACTOR CARDS (expandable sections):

Section "Food & Drink" (chevron, expanded by default):
Factors as 2-column chips:
- "Caffeine ☕" toggle-selectable chip
- "Alcohol 🍷"
- "Water Intake 💧" (shows unit config: "glasses" when selected, expandable mini-config)
- "Meal Quality 🥗" (shows type config: scale 1-10)

Section "Physical":
- "Exercise 🏃" (numeric: minutes)
- "Steps 👟" (auto from Health Connect badge)
- "Screen Time 📱" (numeric: hours)

Section "Mental":
- "Stress Level 😤" (scale 1-10)
- "Meditation 🧘" (boolean)
- "Social Interaction 👥" (scale)

Selected state chips: teal-500/20 bg, teal-500 border, check icon
Config (expands below chip when selected): small inline controls for type/unit

Bottom: "X factors selected" + "Continue" button
```

---

## COMPONENT-LEVEL PROMPTS

### Component: Health Score Ring

```
Design a circular health score widget for Flutter using CustomPainter.

Specifications:
- Outer ring: 12px stroke width, zinc-800 color (background track)
- Inner arc: 12px stroke width, gradient from teal-400 to cyan-300, filled based on score percentage
- Arc starts at -90° (top) and goes clockwise
- Glow effect at arc endpoint: radial glow in cyan-400/40
- Center text: score number in Inter 700 white, "Score" label below in zinc-500 10px
- Below ring (outside): trend arrow + delta text ("↑ 4", teal color if improving, red if declining, zinc-400 if stable)
- Score ranges color adaptation:
  0-30: gradient red-500 → orange-500
  31-60: gradient orange-500 → yellow-400
  61-80: gradient teal-400 → cyan-300
  81-100: gradient teal-400 → emerald-300 (with extra sparkle glow)
- Animation: arc draws from 0 to score value over 1.5s, easeOutCubic curve
- Sizes: Small (64px), Medium (100px), Large (140px)
```

### Component: Insight Card

```
Design a reusable insight card component inspired by shadcn/ui card style.

Anatomy:
- Container: zinc-900 bg, 1px zinc-800 border, 12px radius, 16px padding
- Top row:
  Left: Type badge pill (8px radius, 6px horizontal padding, 4px vertical):
    "Correlation" — teal-900/50 bg, teal-400 text
    "Anomaly" — amber-900/50 bg, amber-400 text
    "Trend" — indigo-900/50 bg, indigo-400 text
    "Recommendation" — purple-900/50 bg, purple-400 text
  Right: "92% confidence" zinc-500 12px mono
- Title: 15px/600 white, single line, marginTop 8px
- Body: 13px/400 zinc-300, max 3 lines, line-height 1.6
- Data visualization (inline, collapsible): 
  For correlation: 2-bar comparison mini chart, 40px tall, teal vs zinc colors
  For anomaly: single spike chart, 40px tall
  For trend: sparkline 3 months, 30px tall
- Footer: zinc-800 border-top, "Based on X days" zinc-500 11px left, Bookmark icon right
- Expanded state: reveals full description + "What you can do:" bullet list (zinc-300 13px) + "Dismiss" ghost button
- Press state: scale 0.98, transition 150ms
```

### Component: Mood Picker

```
Design a mood selection widget for a health journaling app.

Layout:
5 emoji buttons arranged horizontally, equal width, gap 8px:

Each button:
- Container: 56px width, auto height, zinc-900 bg, 1px zinc-800 border, 10px radius
- Emoji: 24px, centered
- Label: 10px zinc-500, centered below emoji

States:
- Default: zinc-900 bg, zinc-800 border
- Hovered/pressed: zinc-800 bg
- Selected: colored bg/border based on mood:
  "Great" 😊: emerald-900/30 bg, emerald-500 border
  "Good" 🙂: teal-900/30 bg, teal-500 border  
  "Okay" 😐: zinc-700/30 bg, zinc-500 border
  "Bad" 😟: orange-900/30 bg, orange-500 border
  "Terrible" 😰: red-900/30 bg, red-500 border
- Selected has subtle scale 1.05 transform

Below picker (animated slide-down when mood selected):
- "Intensity" label zinc-400 12px + value "7/10" right
- Custom slider: 48px height hit area, 6px visible track, rounded thumb 20px diameter
  Thumb: white with 2px border of selected mood color
  Fill: gradient from selected mood color to lighter variant
  Track: zinc-700

Animation: Intensity section slides down with 300ms ease-out when mood first selected
```

### Component: Symptom Chip (Logged)

```
Design a logged symptom display chip/card for a health tracking form.

Collapsed state (default):
- Full width horizontal card: zinc-900 bg, zinc-800 border, 8px radius, 12px 16px padding
- Left: symptom name 14px/500 white
- Center-right: severity badge — pill shape, severity-colored:
  1-3: emerald-900/50 bg, emerald-400 text "Low • 3"
  4-6: yellow-900/50 bg, yellow-400 text "Moderate • 5"
  7-8: orange-900/50 bg, orange-400 text "High • 7"
  9-10: red-900/50 bg, red-400 text "Severe • 9"
- Right: chevron-down icon zinc-500 16px

Expanded state (tap to expand):
- Card smoothly expands (300ms ease-out animation, max-height transition)
- New row: "Severity" label + slider (severity-colored fill based on value)
- New row: "Notes (optional)" zinc-400 label + text input zinc-900 bg zinc-800 border
- Bottom row: "Remove symptom" ghost button with Trash-2 icon red-400 14px left, "Done" ghost button right zinc-300

Overall: Stacked list of these chips with 4px gap, slight spring animation when adding/removing items
```

### Component: Bottom Navigation Bar

```
Design a bottom navigation bar for a health app with 4 tabs.

Specs:
- Height: 72px (including safe area padding 20px + content 52px)
- Background: zinc-950, border-top: 1px zinc-800
- Backdrop blur: blur(20px) with zinc-950/90 for glass effect

4 Tab Items (equal width):
1. Home — House icon, "Home" label
2. Journal — BookOpen icon, "Journal" label
3. Insights — BarChart2 icon, "Insights" label
4. Settings — Settings icon, "Settings" label

Each item (vertical stack, centered, full height):
- Icon: 22px Lucide icon
- Label: 10px text, marginTop 4px

States:
- Active: icon teal-400, label teal-400, subtle teal-400/8 bg pill behind icon (36x28px, 6px radius)
- Inactive: icon zinc-500, label zinc-500
- Press: brief scale 0.9 animation on icon

Notification badge (for Insights tab if new insights available):
- 6px dot, teal-400 bg, positioned top-right of icon
```

---

## FULL APP FLOW PROMPT (for tools like v0.dev)

```
Create a complete mobile app UI for "MedMind", a private health journaling and symptom tracking app.

The app has 4 main screens accessible via bottom navigation:

1. HOME: Dashboard with animated health score ring (0-100), today's summary card (mood/sleep/symptoms at a glance), 7-day streak counter, quick-log shortcuts, and horizontal-scrolling insight preview cards.

2. JOURNAL: List of journal entries as cards (showing date, mood emoji + intensity, symptom chips, sleep duration snippet) with FAB to create new entry. Entry form has 3 tabs: "Mood & Symptoms" (emoji mood picker + symptom cards with severity sliders), "Sleep & Meds" (bedtime/waketime pickers + medication toggles), "Lifestyle & Notes" (boolean/numeric/scale inputs + free text area).

3. INSIGHTS: Prominent animated health score ring at top, tabbed view with: (a) Insight cards ranked by confidence showing correlation discoveries in plain language, (b) Interactive correlation heatmap grid, (c) Scrollable symptom timeline.

4. SETTINGS: Profile section, grouped settings rows for privacy/data/tracking/appearance, danger zone for data deletion.

Design system: Dark theme only. Colors: zinc-950 bg, zinc-900 cards, zinc-800 borders, zinc-50 primary text, zinc-400 secondary text, teal-400 accent/interactive. Font: Inter. Style: shadcn/ui inspired — clean, minimal, data-dense but not overwhelming. Icons: Lucide. 390px mobile viewport. Consistent 12px border radius on cards, 8px radius on inputs.

Show all 4 screens in a single design mockup with bottom navigation visible. Include micro-interaction notes.
```

---

## EXPORT & ACCESSIBILITY NOTES

### Untuk Handoff ke Developer (Flutter)

Ketika prompt di atas menghasilkan design, tambahkan instruksi ini untuk convert ke Flutter:

```
Convert this design to Flutter widget code using these conventions:
- Colors: use Color(0xFF09090B) for zinc-950, Color(0xFF18181B) for zinc-900, etc.
- Typography: GoogleFonts.inter() or TextStyle with fontFamily: 'Inter'
- Spacing: SizedBox(height: 8/12/16/24) or Padding with consistent multiples of 4
- Cards: Container with decoration BoxDecoration(color: zinc900, borderRadius: BorderRadius.circular(12), border: Border.all(color: zinc800))
- Buttons: Primary = ElevatedButton with teal bg, Ghost = TextButton with transparent bg
- State management: Riverpod (ConsumerWidget / ConsumerStatefulWidget)
- Animations: Use flutter_animate package for micro-animations
- Icons: lucide_icons package or icons_plus
```

### Accessibility Checklist untuk Setiap Screen

```
For each screen, ensure:
1. Minimum tap target 44×44px for all interactive elements
2. Color contrast ratio ≥ 4.5:1 for body text, ≥ 3:1 for large text (on dark bg)
3. Semantic labels on all icon-only buttons (Semantics widget in Flutter)
4. Custom paint widgets have Semantics wrapper with meaningful description
5. Screen reader order: logical top-to-bottom, left-to-right
6. Focus indicators visible (use FocusableActionDetector in Flutter)
7. No information conveyed by color alone (always pair with text/icon)
```
