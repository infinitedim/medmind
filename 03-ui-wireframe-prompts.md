# MedMind — UI/UX & Wireframe Generation Prompts

> **Terakhir diperbarui:** 8 Maret 2026 (v3 — Widget API di semua code block, a11y di semua komponen & utilities, Success state 2A/3A)
>
> Prompt-prompt di bawah ini digunakan untuk generate wireframe dan UI/UX design
> menggunakan tools seperti v0.dev, Cursor AI, Claude, ChatGPT, Midjourney, atau Figma AI.
>
> **Aturan penggunaan:**
>
> - Selalu sertakan DESIGN SYSTEM REFERENCE di bawah sebelum prompt screen manapun
> - Setiap prompt sudah self-contained — tidak butuh context tambahan dari luar
> - Status per screen ditandai: ✅ Selesai | 🔄 Partial | ❌ Belum
>
> **Codebase reference:**
>
> - Theme: `lib/app/theme/app_colors.dart`, `app_typography.dart`, `app_theme.dart`
> - Routing: `lib/app/routes/app_router.dart`, `route_names.dart`
> - Bottom nav: `lib/presentation/shared/app_bottom_nav.dart` (✅ 151 LOC)
> - Onboarding welcome: `lib/presentation/pages/onboarding/onboarding_page.dart` (✅ 134 LOC)
>
> **Design Philosophy:**
>
> - Referensi: shadcn/ui, Linear, Vercel Dashboard, Notion
> - Style: Clean, minimal, data-dense tapi tidak overwhelming
> - Typography: Inter (body) / JetBrains Mono (data/numbers) via Google Fonts
> - Color: Zinc neutral base + Teal accent (#14B8A6)
> - Radius: 8px cards, 6px inputs/buttons, 4px badges/chips, 999px pills
> - Spacing: 4px grid system
> - Dark mode only (ThemeMode.dark di `app.dart`)

---

## DESIGN SYSTEM REFERENCE

> **Sertakan blok ini sebagai context sebelum setiap prompt screen.**
> Semua token di bawah sudah diimplementasi di codebase dan WAJIB dipakai secara konsisten.

```
DESIGN SYSTEM — MedMind (Flutter, Material 3, Dark Mode Only)

═══ COLOR TOKENS (from AppColors) ═══
Background:      zinc950 #09090B (Scaffold, body)
Card surface:    zinc900 #18181B (Card bg, input bg)
Border:          zinc800 #27272A (Card border, dividers, input border)
Subtle:          zinc700 #3F3F46 (Disabled border, hover bg)
Muted icon:      zinc600 #52525B
Secondary text:  zinc500 #71717A (Captions, timestamps, hints)
Muted text:      zinc400 #A1A1AA (Subtitles, labels)
Light text:      zinc300 #D4D4D8 (Chip text, secondary labels)
Primary text:    zinc50  #FAFAFA (Headings, primary text)

Accent:          teal500 #14B8A6 (CTA, accent)
Accent hover:    teal400 #2DD4BF (Active icons, links)
Accent bg:       teal500_10 rgba(20,184,166,0.10) (Active pill bg)
Accent bg med:   teal500_20 rgba(20,184,166,0.20) (Selected card bg)

Severity:
  Low     1-3: emerald400 #34D399 text, emerald900_30 bg
  Moderate 4-6: amber400 #FBBF24 text, amber900_20 bg (also yellow-900)
  High    7-8: orange400 #FB923C text, orange900_30 bg
  Severe  9-10: red400 #F87171 text, red900_20 bg

Destructive:     red500 #EF4444 (Delete buttons, alerts)
Insight types:
  Correlation:    teal400/teal900 bg
  Anomaly:        amber400/amber900 bg
  Trend:          indigo400 #818CF8 / indigo900_50 bg
  Recommendation: purple400 #C084FC / purple900_50 bg

Score gradients:
  0-30 (critical):  red500 → orange500
  31-60 (poor):     orange500 → yellow #FACC15
  61-80 (good):     teal400 → cyan300 #67E8F9
  81-100 (excellent): teal400 → emerald300 #6EE7B7

═══ TYPOGRAPHY (from AppTypography — Inter + JetBrains Mono) ═══
Display:       Inter 32px/700 zinc50
H1:            Inter 24px/600 zinc50
H2:            Inter 18px/600 zinc50
H3:            Inter 16px/600 zinc50
Body Medium:   Inter 14px/500 zinc50
Body:          Inter 14px/400 zinc50 height:1.5
Small:         Inter 13px/400 zinc50 height:1.6
Caption:       Inter 12px/400 zinc50 height:1.4
Caption Med:   Inter 12px/500 zinc50
Micro:         Inter 11px/400 zinc500
Overline:      Inter 12px/500 zinc400 letterSpacing:0.8

Muted:         Inter 14px/400 zinc400
Muted Small:   Inter 13px/400 zinc400
Muted Caption: Inter 12px/400 zinc500

Mono Large:    JetBrains Mono 36px/700 zinc50 (health score center)
Mono Medium:   JetBrains Mono 24px/700 zinc50 (time displays)
Mono:          JetBrains Mono 14px/400 zinc50
Mono Small:    JetBrains Mono 12px/400 zinc500 (confidence %)

Accent:        Inter 14px/500 teal400
Accent Small:  Inter 12px/500 teal400
Destructive:   Inter 14px/500 red500

═══ SPACING ═══
4px base grid: 4, 8, 12, 16, 20, 24, 32, 40, 48px
Screen padding: 16px horizontal (or 24px for onboarding)
Card padding: 16px
Section gap: 24px
Inline gap: 8px

═══ COMPONENTS ═══
Card:          zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
Input:         zinc900 bg, 1px zinc800 border, 6px radius, 14px body text
Button Primary: teal500 bg, zinc50 text, 6px radius, 48px height, full-width
Button Outline: transparent bg, 1px zinc800 border, zinc300 text, 6px radius
Button Ghost:  transparent bg, no border, zinc400 text
Button Destructive: red500 bg, zinc50 text
Badge/Chip:    4px radius, 6px h-pad 4px v-pad, 12px text
Pill:          999px radius, zinc900 bg, zinc700 border
Divider:       1px zinc800
Icons:         Lucide (from lucide_icons package), 16px or 20px, stroke style

═══ BOTTOM NAV (already implemented — app_bottom_nav.dart) ═══
Height: 52px content + SafeArea bottom
Background: zinc950, border-top 1px zinc800
4 tabs: Home (LucideIcons.home), Journal (bookOpen), Insights (barChart2), Settings (settings)
Active:   teal400 icon + teal400 label (11px), teal500_10 bg pill 36×28 6px radius behind icon
Inactive: zinc500 icon + zinc500 label (11px)

═══ INTERACTION STATES ═══
Every screen/component MUST handle:
  - Default:  Normal content display
  - Loading:  Shimmer/skeleton placeholder on zinc900 bg
  - Empty:    Centered illustration + heading zinc50 18px/600 + subtitle zinc400 14px + CTA button
  - Error:    Red-tinted card or inline message + "Try again" button
  - Success:  Brief SnackBar confirmation at bottom
```

---

## ✅ ARSIP — SCREEN YANG SUDAH SELESAI

> Screen-screen di bawah ini sudah fully implemented di codebase.
> Disimpan sebagai referensi desain — **tidak perlu generate ulang.**

<details>
<summary>✅ 1A. Welcome Screen — <code>onboarding_page.dart</code> (134 LOC)</summary>

**File:** `lib/presentation/pages/onboarding/onboarding_page.dart`

Implemented: Scaffold zinc950 bg, SafeArea, Column centered. Brain icon (80×80 circle, teal500_10 bg, teal400 icon 40px, boxShadow teal500 alpha 0.3 blur 40 spread 4). "MedMind" Display text. Tagline Body zinc400 centered. 3 FeaturePill (999px radius, zinc900 bg, zinc700 border): Brain "On-device AI", Shield "100% Private", WifiOff "Offline-first". "Get Started" ElevatedButton full-width 48px → navigates to symptomSetup. "Import backup" TextButton zinc400. Shield icon 14px + "Your data never leaves your device" mutedCaption.

</details>

<details>
<summary>✅ Bottom Navigation Bar — <code>app_bottom_nav.dart</code> (151 LOC)</summary>

**File:** `lib/presentation/shared/app_bottom_nav.dart`

Implemented: AppShell wraps GoRouter ShellRoute. \_MedMindBottomNav: Container zinc950 bg, border-top 1px zinc800, SafeArea, 52px height. 4 \_NavItem equal-width: Home/Journal/Insights/Settings with LucideIcons. Active: teal500_10 bg pill 36×28 6px radius + teal400 icon 20px + teal400 label micro. Inactive: zinc500 icon + zinc500 label. GestureDetector opaque → `context.go()`.

</details>

<details>
<summary>✅ Master Design System — theme files (524 LOC total)</summary>

**Files:**

- `lib/app/theme/app_colors.dart` (71 LOC) — All color tokens
- `lib/app/theme/app_typography.dart` (93 LOC) — Inter + JetBrains Mono scale
- `lib/app/theme/app_theme.dart` (360 LOC) — Full Material 3 ThemeData: ColorScheme, 20+ component themes

</details>

---

## 🔄 SCREEN 1B: SYMPTOM SETUP (Onboarding Step 2 of 4)

> **Status:** 🔄 Partial (~30%) — skeleton ada, belum fungsional
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/onboarding/symptom_setup_page.dart` (51 LOC — needs expansion)
> **Widget:** `SymptomSetupPage` extends `StatelessWidget` → harus menjadi `ConsumerStatefulWidget` (Riverpod)
> **Widget API:** `SymptomSetupPage({Key? key})` — target: `ConsumerStatefulWidget`
> **State:** `selectedSymptomIds (Set<String>)`, `searchQuery (String)`, `activeCategory (SymptomCategory?)`
> **Provider needed:** `symptomSetupNotifier` (belum ada), `allSymptomsProvider` (belum ada)
> **Route:** `/onboarding/symptoms` (sudah ada di `app_router.dart`)
>
> **✅ Sudah ada (51 LOC):**
>
> - Scaffold zinc950 bg + AppBar "Select Symptoms" (h2) + "2 of 4" indicator
> - Body heading "What would you like to track?" (h1) + subtitle (muted)
> - "Continue" ElevatedButton (teal500, full-width, 48px) di bottom
>
> **❌ Belum ada:**
>
> - Search input (TextField + debounce 300ms) — widget belum dibuat
> - Category filter chips (horizontal ScrollView, SymptomCategory enum) — widget belum dibuat
> - Symptom grid (GridView.builder + selection state + tap animation) — widget belum dibuat
> - Selected count indicator ("X selected" text)
> - Loading shimmer state (8 skeleton cards)
> - Empty search result state
> - Error state (jika data gagal load dari datasource)
> - Konversi widget: `StatelessWidget` → `ConsumerStatefulWidget`
> - Providers: `symptomSetupNotifier`, `allSymptomsProvider`

```
Using the MedMind design system, create the Symptom Selection onboarding screen (step 2 of 4).

Page: SymptomSetupPage({Key? key}) — ConsumerStatefulWidget
State: selectedSymptomIds (Set<String>), searchQuery (String), activeCategory (SymptomCategory?)
Watches: allSymptomsProvider → List<Symptom>, symptomSetupNotifier → Set<String>

EXISTING (jangan ubah):
- Scaffold bg: AppColors.zinc950
- AppBar title: "Select Symptoms" (AppTypography.h2), actions: "2 of 4" (caption zinc400), SizedBox(w:16)
- Body padding: EdgeInsets.all(16)
- Heading: "What would you like to track?" (AppTypography.h1)
- Subtitle: "Select symptoms to monitor. You can change this later." (AppTypography.muted)

YANG PERLU DITAMBAHKAN:

[Search Input] — below subtitle, SizedBox(height: 16)
- Container: zinc900 bg, 1px zinc800 border, 6px radius
- Row: LucideIcons.search (16px, zinc500) + SizedBox(w:8) + Expanded TextField
- Placeholder: "Search symptoms..." zinc500 14px body
- Clear button (X icon) appears when text is not empty
- Debounced search: 300ms, filters symptom grid

[Category Filter Chips] — below search, SizedBox(height: 12)
- Horizontal ScrollView, 8px gap between chips
- Chips: "All" (default active), "Neurological", "Digestive", "Respiratory", "Musculoskeletal", "Psychological", "Skin", "General"
  → Maps to SymptomCategory enum values: neurological, digestive, respiratory, musculoskeletal, psychological, skin, general
  ⚠️ NOTE: Enum value is `psychological` (bukan "Mental Health") — gunakan enum name langsung
- Active chip: teal500_20 bg, teal400 text, 1px teal500 border, 4px radius
- Inactive chip: zinc800 bg, zinc500 text, 1px zinc800 border, 4px radius
- Caption medium (12px/500) text

[Symptom Grid] — Expanded area below chips, SizedBox(height: 12)
- GridView.builder: 2 columns, crossAxisSpacing: 8, mainAxisSpacing: 8
- childAspectRatio: 2.8 (wide cards)
- Each symptom card:
  Container: zinc900 bg, 1px zinc800 border, 8px radius, padding 12px h, 8px v
  Row: emoji Text (20px) + SizedBox(w:8) + Column(crossAxisAlignment: start) [
    symptom name (bodyMedium 14px/500 zinc50),
    category badge: 4px radius pill, 11px micro text
  ]
  Selected state: teal500_20 bg, 1px teal500 border, check icon (LucideIcons.check, 14px teal400) positioned top-right
  Tap animation: scale 0.95 → 1.0, 150ms, using flutter_animate

- Pre-selected (highlighted) defaults: Headache, Fatigue, Anxiety, Nausea, Back Pain, Sleep Issues
- Data source: list of Symptom entities from SymptomLocalDataSource (30-50 items, categorized)

[Footer] — fixed at bottom, above SafeArea
- Row: mainAxisAlignment spaceBetween
  Left: "X selected" text (mutedSmall zinc400)
  Right: ElevatedButton "Continue" (teal500 bg, zinc50 text, 6px radius)
    Disabled state: zinc700 bg, zinc500 text — when 0 selected
- On tap Continue: save selected symptom IDs → navigate to lifestyleSetup (step 3)

INTERACTION STATES:
- Default:  Grid shows all symptoms, "All" filter active
- Searching: Grid filters in real-time, show "No results found" empty state if none match
- Empty search result: LucideIcons.searchX (40px zinc500) + "No symptoms match" h3 + "Try a different search term" muted
- Loading (first load): 8 shimmer cards (zinc900 bg, shimmer gradient zinc800→zinc700→zinc800)
- Error (data load fail): MedMindErrorWidget(message: "Could not load symptoms", onRetry: reload) — centered in grid area
- Success (continue): Save selectedSymptomIds → brief SnackBar "Symptoms saved ✓" (teal400 leading icon) → navigate lifestyleSetup

Flutter specifics:
- Widget: ConsumerStatefulWidget (needs Riverpod for selected symptoms state)
- SearchController for TextField
- Category filter: ValueNotifier<SymptomCategory?> (null = "All")
- Selected set: StateNotifier<Set<String>> of symptom IDs
```

---

## ❌ SCREEN 1C: LIFESTYLE FACTORS SETUP (Onboarding Step 3 of 4)

> **Status:** ❌ Belum dikerjakan — file tidak ada
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File to create:** `lib/presentation/pages/onboarding/lifestyle_setup_page.dart`
> **Widget:** `LifestyleSetupPage` extends `ConsumerStatefulWidget`
> **Widget API:** `LifestyleSetupPage({Key? key})` — `ConsumerStatefulWidget`
> **State:** `selectedFactorIds (Set<String>)`, `expandedSections (Map<String, bool>)`
> **Providers:** `allLifestyleFactorsProvider`, `selectedFactorsNotifier` (belum ada)
> **Route to add:** `/onboarding/lifestyle` di `app_router.dart`
> **Domain entities:** `LifestyleFactor` (id, name, type: FactorType, unit?), `FactorType` enum (boolean, numeric, scale)

```
Using the MedMind design system, create the Lifestyle Factors selection screen (onboarding step 3 of 4).

Page: LifestyleSetupPage({Key? key}) — ConsumerStatefulWidget
State: selectedFactorIds (Set<String>), expandedSections (Map<String, bool>)
Watches: allLifestyleFactorsProvider → List<LifestyleFactor>, selectedFactorsNotifier → Set<String>

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- AppBar: back arrow (ghost, zinc400) left, "3 of 4" step pills top-right (caption zinc400)
- Body: SafeArea + Padding(all: 16)

[Header]
- "Lifestyle factors to track" — AppTypography.h1 (24px/600 zinc50)
- SizedBox(height: 8)
- "What habits affect your health? Select to track daily." — AppTypography.muted (14px/400 zinc400)
- SizedBox(height: 24)

[Factor Groups] — Expanded, SingleChildScrollView
Three collapsible sections, each:
- Section header: Row [
    category icon (20px zinc400) + SizedBox(w:8) +
    category name (h3 16px/600 zinc50) + Spacer +
    expand/collapse chevron (LucideIcons.chevronDown/chevronUp, 20px zinc500)
  ]
- Divider: 1px zinc800, SizedBox(height: 12) below header
- Content: Wrap widget, spacing: 8, runSpacing: 8
- SizedBox(height: 24) between sections

Section "Food & Drink" (LucideIcons.coffee, expanded by default):
- "Caffeine ☕" — FactorType.boolean
- "Alcohol 🍷" — FactorType.boolean
- "Water Intake 💧" — FactorType.numeric (unit: "glasses")
- "Meal Quality 🥗" — FactorType.scale (1-10)

Section "Physical" (LucideIcons.activity):
- "Exercise 🏃" — FactorType.numeric (unit: "minutes")
- "Steps 👟" — FactorType.numeric (auto from Health Connect — show HC badge)
- "Screen Time 📱" — FactorType.numeric (unit: "hours")

Section "Mental" (LucideIcons.brain):
- "Stress Level 😤" — FactorType.scale (1-10)
- "Meditation 🧘" — FactorType.boolean
- "Social Interaction 👥" — FactorType.scale (1-10)

Each factor chip:
- Container: zinc900 bg, 1px zinc800 border, 8px radius, padding 10px h, 8px v
- Row: emoji (16px) + SizedBox(w:6) + factor name (captionMedium 12px/500 zinc300)
- Selected: teal500_20 bg, 1px teal500 border, LucideIcons.check (12px teal400) after name
- When a selected factor needs config (numeric/scale):
  Animated expand below the chip (200ms ease-out):
  - For numeric: Row [ "-" icon button zinc700 | value text monoSmall | "+" icon button zinc700 ] + unit label zinc500
  - For scale: Mini text "1-10 scale" zinc500 caption (config in daily log, not here)

[Footer] — fixed bottom
- Row: "X factors selected" mutedSmall zinc400 left + "Continue" ElevatedButton right
- Continue → navigate to securitySetup (step 4)

INTERACTION STATES:
- Default: Food & Drink expanded, others collapsed
- Loading: Shimmer cards (3 groups × 3-4 items)
- Empty: Not applicable — pre-defined factor list always available
- Error: Not applicable — all factors are bundled in app, no remote fetch
- Success (continue): Save selections → SnackBar "Factors saved ✓" → navigate to securitySetup

Flutter specifics:
- ConsumerStatefulWidget with ExpansionTile-like custom widgets
- AnimatedContainer (200ms ease-out) for collapsible sections
- ValueNotifier<Set<String>> for selected factor IDs
- flutter_animate for chip selection spring (scale 0.95 → 1.0, 150ms)
- Save to Isar via LifestyleFactorRepository on Continue
```

---

## ❌ SCREEN 1D: SECURITY SETUP (Onboarding Step 4 of 4)

> **Status:** ❌ Belum dikerjakan — file tidak ada
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File to create:** `lib/presentation/pages/onboarding/security_setup_page.dart`
> **Widget:** `SecuritySetupPage` extends `ConsumerWidget`
> **Widget API:** `SecuritySetupPage({Key? key})` — `ConsumerWidget`
> **State:** `biometricEnabled (bool)`, `autoLockMinutes (int)`
> **Providers:** `keystoreNotifier`, `biometricAvailableProvider` (belum ada)
> **Route to add:** `/onboarding/security` di `app_router.dart`
> **Platform:** `KeystoreChannel` (sudah implemented, 193 LOC)

```
Using the MedMind design system, create the Security Setup screen (onboarding step 4 of 4).

Page: SecuritySetupPage({Key? key}) — ConsumerWidget
Watches: keystoreNotifier → KeystoreState, biometricAvailableProvider → bool
Platform: KeystoreChannel.canAuthenticate(), .setBiometricEnabled()

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- AppBar: back arrow left, "4 of 4" step indicator right (caption zinc400)
- Body: SafeArea + Padding(all: 16)

[Header]
- "Protect your data" — AppTypography.h1 (24px/600 zinc50)
- SizedBox(height: 8)
- "MedMind uses end-to-end encryption. Add biometric lock for extra security." — AppTypography.muted
- SizedBox(height: 32)

[Center Illustration]
- Container: 120px circle, zinc900 bg, 1px zinc800 border
- Center: LucideIcons.fingerprint (48px, teal400)
- boxShadow: teal500 alpha 0.15, blur 30
- SizedBox(height: 32)

[Option Cards] — Column, 12px gap
Card 1 — "Enable Biometric Lock":
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Row: LucideIcons.fingerprint (20px, teal400) + SizedBox(w:12) +
  Expanded Column [
    "Enable Biometric Lock" bodyMedium (14px/500 zinc50),
    SizedBox(h:4),
    "Unlock with fingerprint or face ID" caption zinc400
  ] + Switch (teal500 when on, zinc700 when off — MaterialSwitch with theme)

Card 2 — "Auto-lock after" (visible only when biometric toggle ON):
- AnimatedContainer/AnimatedCrossFade, 200ms ease-out
- Same card style: zinc900 bg, zinc800 border, 12px radius
- Row: LucideIcons.timer (20px, zinc400) + SizedBox(w:12) +
  "Auto-lock after" bodyMedium zinc50 + Spacer +
  DropdownButton: "5 minutes" (options: 1 min, 5 min, 15 min, 30 min) — zinc900 bg, zinc800 border, 6px radius

[Info Box] — SizedBox(height: 24)
- Container: zinc900 bg, 12px radius, 16px padding
  + left border: 2px teal500 (via BoxDecoration border.left)
- Row: LucideIcons.shieldCheck (16px, teal400) + SizedBox(w:12) +
  Expanded Text: "Your encryption key is stored in Android Keystore, a hardware-secured chip. MedMind cannot access your data without your biometric." caption zinc400 height:1.5

[Footer] — Spacer + bottom buttons
- Row: TextButton "Set Up Later" (ghost, zinc400) + SizedBox(w:12) + Expanded ElevatedButton "Finish Setup"
- "Set Up Later" → skip biometric, mark onboarding complete → navigate to home "/"
- "Finish Setup" → save biometric preference, mark onboarding complete → navigate to home "/"

INTERACTION STATES:
- Default: Biometric toggle OFF, auto-lock card hidden
- Biometric ON: Auto-lock card slides in (AnimatedCrossFade), switch turns teal
- Loading (biometric check): Brief CircularProgressIndicator while checking device capability
- Error (no biometric hardware): Card 1 disabled (zinc700 bg, zinc600 text), subtitle: "Biometric not available on this device"
- Success (finish): Mark onboarding complete → navigate to home "/" with fade transition

Flutter specifics:
- ConsumerWidget (minimal state: biometric toggle + auto-lock dropdown)
- AnimatedCrossFade for auto-lock card reveal (200ms)
- KeystoreChannel.canAuthenticate() called on initState
- UserPreferencesRepository.setBiometricEnabled() on toggle
- SharedPreferences or Isar to persist onboarding-complete flag
```

---

## ❌ SCREEN 2A: HOME DASHBOARD

> **Status:** ❌ Belum dikerjakan — stub hanya centered text "Home"
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/home/home_page.dart` (17 LOC — needs full rewrite)
> **Widget:** `HomePage` → rewrite as `ConsumerWidget`
> **Widget API:** `HomePage({Key? key})` — `ConsumerWidget`
> **Providers watched:** `todayJournalEntryProvider`, `healthScoreProvider`, `recentInsightsProvider`, `streakCountProvider`
> **Child widgets:** `DailySummaryCard`, `QuickLogButtons`, `HealthScoreRing`
> **Widget files needed (all empty, 0 bytes):**
>
> - `lib/presentation/widgets/home/health_score_ring.dart` — lihat Component prompt
> - `lib/presentation/widgets/home/quick_log_buttons.dart` — lihat Component prompt
> - `lib/presentation/widgets/home/daily_summary_card` — ⚠️ file tanpa extension, rename ke `.dart`
>
> **Route:** `/` (sudah ada)

```
Using the MedMind design system, create the main Home Dashboard screen.

Page: HomePage({Key? key}) — ConsumerWidget
Watches: todayJournalEntryProvider → JournalEntry?, healthScoreProvider → HealthScore?,
         recentInsightsProvider → List<Insight>, streakCountProvider → int
Children: DailySummaryCard, QuickLogButtons, HealthScoreRing (see COMPONENT prompts)

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- Bottom nav visible (already handled by AppShell)
- Body: SafeArea + SingleChildScrollView + Padding(h: 16)

[Top Bar] — SizedBox(height: 8) from top
- Row: Column(crossAxisAlignment: start) [
    greeting text h2 (18px/600 zinc50):
      before 12:00 → "Good morning"
      12:00-17:00 → "Good afternoon"
      17:00+ → "Good evening"
    SizedBox(h:4),
    date text: "Monday, March 8" — caption zinc400 (format via intl DateFormat)
  ] + Spacer + Row [
    IconButton: LucideIcons.bell (20px zinc400) — notification, badge dot (6px circle teal400) if unread insights
    SizedBox(w:4),
    IconButton: LucideIcons.settings (20px zinc400) → navigate /settings
  ]
- SizedBox(height: 24)

[Today's Summary Card] — Full-width card
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Header Row: "Today's Health" overline (12px/500 zinc400 letterSpacing:0.8) left +
  TextButton "Log Entry" ghost (accent small 12px/500 teal400) + LucideIcons.plus (14px teal400) right
- SizedBox(height: 16)

IF today has entry:
  - Row: [HealthScoreRing widget (80px)] + SizedBox(w:16) + Expanded Column [
      score label: "78" monoMedium (24px/700 zinc50) + " Score" caption zinc500
      SizedBox(h:4),
      trend Row: LucideIcons.trendingUp (14px teal400) + " ↑ 4 from yesterday" accentSmall teal400
    ]
  - SizedBox(height: 16)
  - Row of 3 stat chips, equal flex:
    Each chip: Container zinc800 bg, 8px radius, 8px padding
    Column center: icon (16px zinc400) + SizedBox(h:4) + value (captionMedium zinc300) + SizedBox(h:2) + label (micro zinc500)
    Chip 1: LucideIcons.moon + "7h 20m" + "Sleep"
    Chip 2: LucideIcons.activity + "3/10" + "Symptoms"
    Chip 3: mood emoji (16px) + "Good" + "Mood"
  - Divider: 1px zinc800, SizedBox(height: 12)
  - "Last logged: Today, 9:32 PM" — micro zinc500

IF today has NO entry:
  - Center Column: LucideIcons.plusCircle (32px, teal400) + SizedBox(h:12) +
    "No entry yet today" bodyMedium zinc300 + SizedBox(h:4) +
    "Tap to start logging" mutedCaption zinc500

- SizedBox(height: 24)

[Streak & Quick Actions]
- Streak card: Container zinc900 bg, zinc800 border, 12px radius, 12px padding
  Row: "🔥" (20px) + SizedBox(w:8) + "7-day streak" bodyMedium zinc50 + Spacer + "Keep it going!" caption zinc400

- SizedBox(height: 12)
- Quick log row: Row of 3, gap 8px, each Expanded
  Each: GestureDetector → Container zinc900 bg, 1px zinc800 border, 8px radius, 12px padding
  Column center: icon (20px teal400) + SizedBox(h:8) + label (caption zinc300)
  Card 1: LucideIcons.smile → "Log Mood" → navigate /journal/new?tab=mood
  Card 2: LucideIcons.plus → "Log Symptom" → navigate /journal/new?tab=symptom
  Card 3: LucideIcons.fileText → "Add Note" → navigate /journal/new?tab=notes

- SizedBox(height: 24)

[Recent Insights] (show only if insights available)
- Row: "Latest Insights" h2 (18px/600 zinc50) + Spacer + TextButton "See all →" accentSmall teal400 → navigate /insights
- SizedBox(height: 12)
- Horizontal ScrollView (height: 160px) of InsightPreviewCards, 12px gap
  Each card: Container 260px wide, zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
  - InsightType badge pill: 4px radius, 6px h-pad, 4px v-pad
    Correlation: teal500_20 bg, teal400 text
    Anomaly: amber900_20 bg, amber400 text
    Trend: indigo900_50 bg, indigo400 text
  - SizedBox(h:8)
  - Title: bodyMedium (14px/500 zinc50), maxLines: 1, overflow ellipsis
  - SizedBox(h:4)
  - Body: small (13px/400 zinc400), maxLines: 2, overflow ellipsis
  - Spacer
  - Bottom Row: confidence bar (Container height:3, teal400 fill, zinc800 track, 999px radius) + SizedBox(w:8) + "87%" monoSmall zinc500

If no insights: show nothing (section hidden)
If < 14 days data: replace with progress card showing "Journal X more days to unlock insights"

- SizedBox(height: 24)

[This Week Strip] — mini calendar
- Row of 7 day circles: Column [ day abbrev micro zinc500, SizedBox(h:4), circle (32px) ]
  Today: teal500 bg, zinc50 text (bodyMedium)
  Past with entry: zinc800 bg, zinc300 text, mood dot (4px, mood color) below
  Past without entry: zinc900 bg, zinc600 text
  Future: zinc900 bg, zinc700 text
- SizedBox(height: 8)
- Below each circle: symptom count badge (micro zinc500) if > 0 symptoms that day
- SizedBox(height: 32) — bottom padding

INTERACTION STATES:
- Loading: Skeleton shimmer for summary card (pulse zinc800→zinc700→zinc800), 3 quick log cards shimmer, no insights section
- Empty (first ever): Summary card shows "Welcome to MedMind!" h2 + "Create your first journal entry to start tracking." muted + ElevatedButton "Start Journaling" → /journal/new
- Error (data load fail): Summary card shows LucideIcons.alertTriangle (24px red400) + "Could not load today's data" body zinc300 + TextButton "Retry" accent
- No insights: Insights section completely hidden
- Success (data loaded): All sections render with live data — summary card with score + stats, streak counter, quick log buttons active, insight carousel visible if ≥ 14 days of entries

Flutter specifics:
- ConsumerWidget, watch journalEntriesProvider for today
- Greeting computed from DateTime.now().hour
- Date formatted via intl package: DateFormat('EEEE, MMMM d')
- HealthScoreRing is a separate widget (see Component prompt below)
```

---

## ❌ SCREEN 3A: JOURNAL LIST PAGE

> **Status:** ❌ Belum dikerjakan — stub "Journal" text
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/journal/journal_list_page.dart` (17 LOC — needs full rewrite)
> **Widget:** `JournalListPage` → rewrite as `ConsumerStatefulWidget`
> **Widget API:** `JournalListPage({Key? key})` — `ConsumerStatefulWidget`
> **State:** `isSearchVisible (bool)`, `activeFilter (JournalFilter)`, `scrollController (ScrollController)`
> **Providers watched:** `journalEntriesProvider`, `journalSearchProvider`
> **Route:** `/journal` (sudah ada), FAB navigates to `/journal/new`
>
> **⚠️ ENTITY GAP:** `JournalEntry` entity saat ini TIDAK punya field `isDraft`/`status`.
> Perlu tambahkan `@Default(false) bool isDraft` ke `journal_entry.dart` sebelum implementasi.
> Juga belum ada computed property `isComplete` — pertimbangkan: `bool get isComplete => mood != null || symptoms.isNotEmpty`.

```
Using the MedMind design system, create the Journal entries list page.

Page: JournalListPage({Key? key}) — ConsumerStatefulWidget
State: isSearchVisible (bool), activeFilter (JournalFilter), scrollController (ScrollController)
Watches: journalEntriesProvider → List<JournalEntry>, journalSearchProvider → List<JournalEntry>

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- Bottom nav visible
- Body: SafeArea

[Top Bar] — Padding(h: 16, top: 8)
- Row: "Journal" AppTypography.h1 (24px/600 zinc50) + Spacer + Row [
    IconButton LucideIcons.search (20px zinc400) → toggles search bar
    SizedBox(w:4),
    IconButton LucideIcons.filter (20px zinc400) → opens filter bottom sheet
  ]

[Search Bar] — collapsible, animated (200ms ease-out)
- AnimatedContainer: visible when search toggled ON
- Container: zinc900 bg, 1px zinc800 border, 6px radius, margin h:16 top:8
- Row: LucideIcons.search (16px zinc500) + SizedBox(w:8) + Expanded TextField (body zinc50, hint "Search notes..." zinc500) + IconButton LucideIcons.x (16px zinc500) to close

[Tab Filter Row] — Padding(h: 16, top: 12, bottom: 8)
- SingleChildScrollView horizontal
- 4 pill tabs, gap 8px:
  "All" | "This Week" | "This Month" | "Drafts"
- Active tab: teal500_20 bg, teal400 text, 1px teal500 border, 999px radius, padding h:12 v:6
- Inactive tab: zinc900 bg, zinc500 text, 1px zinc800 border, 999px radius, padding h:12 v:6
- Caption medium (12px/500) text

[Journal Entry Cards] — Expanded, ListView.builder with padding h:16
- 8px gap between cards
- Pull-to-refresh: RefreshIndicator (teal400 color)
- Lazy loading: add entries as user scrolls (offset-based pagination, 20 per page)
- Loading more indicator: SizedBox(height: 48) with small CircularProgressIndicator (teal400) at bottom

Each card — JournalEntryCard widget:
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- GestureDetector → navigate to /journal/entry?id={entryId}

Card anatomy:
- Top row: "Mon, Mar 2" captionMedium zinc300 (12px/500) left +
  status badge right:
    "Complete": zinc700 bg, zinc300 text, 4px radius
    "Draft": amber900_20 bg, amber400 text, 4px radius

- SizedBox(height: 12)
- Mood row: Row [
    mood emoji Text (24px) + SizedBox(w:8) +
    mood label bodyMedium (14px/500 zinc50) e.g. "Good" +
    SizedBox(w:8) +
    intensity bar (Container h:6, w:80, zinc800 bg, 999px radius, inner teal400 fill proportional to moodIntensity/10) +
    SizedBox(w:6) + "8/10" monoSmall zinc500
  ]
  No mood: skip this row

- SizedBox(height: 8)
- Symptoms row: SingleChildScrollView horizontal, Row gap:6
  Each chip: Container 4px radius, zinc800 bg, 1px zinc700 border, padding h:8 v:4
    Text: "{name} • {severity}" caption (12px) zinc300
    chip border color varies by severity: emerald for 1-3, amber for 4-6, orange for 7-8, red for 9-10

  If > 3 symptoms: show "+N more" chip (zinc700 bg, zinc500 text)
  No symptoms: skip this row

- SizedBox(height: 8)
- Sleep row (if sleepRecord exists): Row [
    LucideIcons.moon (14px zinc400) + SizedBox(w:6) +
    sleepDuration monoSmall zinc300 (e.g. "7h 30m") +
    SizedBox(w:8) +
    3 quality dots (4px circles): filled dots = quality/3.3 rounded, filled = teal400, empty = zinc700
  ]

- SizedBox(height: 8)
- Free text snippet (if freeText exists):
  Text: freeText, maxLines: 2, overflow: ellipsis, style: small (13px) zinc400 italic

- Divider: 1px zinc800, SizedBox(height: 8)
- Bottom row: Row [
    lifestyle tags: Text "Caffeine • Alcohol • No Exercise" micro zinc500, maxLines: 1, ellipsis +
    Spacer +
    IconButton LucideIcons.edit3 (14px zinc500) ghost → navigate to edit
  ]

[FAB] — Positioned bottom-right (right:16, bottom:16 above nav)
- Show FAB if no entry for today yet
- FloatingActionButton: teal500 bg, zinc50 LucideIcons.plus (24px), 56px size
- onTap → navigate /journal/new
- Elevation: 0 (flat, use border zinc800 for definition)

INTERACTION STATES:
- Loading (initial): 3 shimmer cards (Container zinc900 bg, shimmer gradient, 12px radius, height: 180)
- Empty (no entries ever): Centered column:
    LucideIcons.bookOpen (48px, zinc600) +
    SizedBox(h:16) + "No entries yet" h2 zinc50 +
    SizedBox(h:8) + "Start by logging how you're feeling today." muted zinc400 +
    SizedBox(h:24) + ElevatedButton "Create First Entry" → /journal/new
- Empty (filtered but has entries): "No entries match your filter." muted zinc400 + TextButton "Clear filters"
- Error: Card with LucideIcons.alertTriangle + "Failed to load entries" + "Retry" button
- Search no results: LucideIcons.searchX (40px zinc500) + "No entries match" h3 + "Try different keywords" muted
- Swipe to delete: Dismissible with red500 bg, LucideIcons.trash2 icon, confirm SnackBar with "Undo" action (5s timeout)
- Success (entries loaded): Cards render with live data, pull-to-refresh completes with brief teal400 spin, FAB visible if no today entry
- Delete success: SnackBar "Entry deleted" zinc800 bg with "Undo" TextButton teal400 (5s auto-dismiss)

Flutter specifics:
- ConsumerStatefulWidget with ScrollController for pagination
- journalEntriesProvider.family<DateRange?> for filtered queries
- Dismissible widget for swipe-to-delete
- RefreshIndicator for pull-to-refresh
```

---

## ❌ SCREEN 3B: JOURNAL ENTRY FORM — Mood & Symptoms Tab

> **Status:** ❌ Belum dikerjakan — stub + empty widget files
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/journal/journal_entry_page.dart` (27 LOC — needs major expansion)
> **Widget API:** `JournalEntryPage({Key? key, String? entryId})` — `ConsumerStatefulWidget`
> **State:** `tabController (TabController)`, form state via `journalFormNotifier`
> **Providers watched:** `journalFormNotifier`, `existingEntryProvider(entryId)`
> **Child widgets:** `MoodPicker`, `SymptomSelector`, `SleepInput`, `MedicationInput`, `FreeTextInput`
> **Widget files (all empty, 0 bytes):**
>
> - `lib/presentation/widgets/journal/mood_picker.dart`
> - `lib/presentation/widgets/journal/symptom_selector.dart`
>
> **Route:** `/journal/new` (new) and `/journal/entry?id=X` (edit)

```
Using the MedMind design system, create the Journal Entry Form page with Tab 1: Mood & Symptoms.

Page: JournalEntryPage({Key? key, String? entryId}) — ConsumerStatefulWidget
State: tabController (TabController), form state via journalFormNotifier
Watches: journalFormNotifier → JournalFormState, existingEntryProvider(entryId) → JournalEntry?
Children: MoodPicker, SymptomSelector, SleepInput (Tab 2), MedicationInput (Tab 2), FreeTextInput (Tab 3)

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- No bottom nav (full-screen form — NOT wrapped in AppShell)
- AppBar:
  Leading: back arrow IconButton (zinc400)
  Title: new mode → "New Entry" h2, edit mode → date "Mon, Mar 2" h2
  Actions: Row [
    TextButton "Save Draft" ghost zinc400 (only if form has changes),
    SizedBox(w:4),
    ElevatedButton "Save" (teal500 bg, compact size: height 36, padding h:16)
    → disabled (zinc700 bg, zinc500 text) until at least 1 field is filled
  ]

[Date Selector] — below AppBar
- Padding h:16, Container zinc900 bg, zinc800 border, 8px radius, padding h:12 v:8
- Row: LucideIcons.calendar (16px zinc400) + SizedBox(w:8) + date text bodyMedium zinc50 +
  Spacer + LucideIcons.chevronDown (14px zinc500)
- Tap → showDatePicker (DatePickerTheme already defined in app_theme.dart)
- Default: DateTime.now()

[Tab Bar] — Padding h:16, SizedBox(height: 8)
- TabBar with 3 tabs, indicator: teal400 2px underline
- Active tab: accent (14px/500 teal400)
- Inactive tab: muted (14px/400 zinc400)
- Tabs: "Mood & Symptoms" | "Sleep & Meds" | "Lifestyle & Notes"
- Default selected: tab 0

[Tab 1 Content — Mood & Symptoms] — Expanded, SingleChildScrollView, Padding h:16

MOOD SECTION:
- Overline: "HOW ARE YOU FEELING?" (12px/500 zinc400, letterSpacing 0.8)
- SizedBox(height: 12)

- MoodPicker widget (file: mood_picker.dart):
  Row of 5 mood buttons, equal flex, gap: 8
  Each button Container:
    56px wide, zinc900 bg, 1px zinc800 border, 10px radius
    Column center: emoji (24px), SizedBox(h:4), label micro (11px zinc500)

    Moods (from Mood enum):
      great 😊 — selected: emerald900_30 bg, emerald400 border
      good  🙂 — selected: teal500_20 bg, teal500 border
      okay  😐 — selected: zinc700 bg (Color(0x4D3F3F46)), zinc500 border
      bad   😟 — selected: orange900_30 bg, orange400 border
      terrible 😰 — selected: red900_20 bg, red400 border

    Selected: scale 1.05 transform (flutter_animate, 150ms)
    Pressed: brief scale 0.95

- Intensity slider (animated slide-down, 300ms ease-out, only shows after mood selected):
  SizedBox(height: 16),
  Row: "Intensity" overline zinc400 + Spacer + value monoSmall zinc50 "7/10"
  SizedBox(height: 8),
  SliderTheme (from app_theme.dart): teal400 active, zinc700 inactive, 6px track, 20px thumb
    Slider(min: 1, max: 10, divisions: 9, value: moodIntensity)
    Thumb: white 20px circle with 2px border of mood color

- SizedBox(height: 32)

SYMPTOMS SECTION:
- Row: Overline "SYMPTOMS TODAY" left + TextButton "+ Add" accentSmall teal400 right (LucideIcons.plus 14px teal400 before text)
- SizedBox(height: 12)

- SymptomSelector widget (file: symptom_selector.dart):
  IF no symptoms logged:
    Container zinc900 bg, zinc800 border dashed (CustomPaint or border style), 8px radius, padding 24
    Center: "No symptoms today — looks good! 💪" small zinc500 italic

  IF symptoms logged — Column of SymptomChipCard widgets, gap: 4
    Each SymptomChipCard (collapsed):
      Container full-width, zinc900 bg, 1px zinc800 border, 8px radius, padding h:16 v:12
      Row: symptom name bodyMedium (14px/500 zinc50) +
        Spacer +
        severity pill (4px radius, 6px h-pad, 4px v-pad):
          1-3: "Low • 3" emerald400/emerald900_30
          4-6: "Mod • 5" amber400/amber900_20
          7-8: "High • 7" orange400/orange900_30
          9-10: "Severe • 9" red400/red900_20
        SizedBox(w:8) + LucideIcons.chevronDown (16px zinc500)

    Expanded state (tap to expand, 300ms ease-out):
      Card expands to show:
      - SizedBox(h:12) + Divider 1px zinc800
      - SizedBox(h:12)
      - "Severity" overline + value monoSmall right
      - Slider (severity-colored: emerald → amber → orange → red based on value)
      - SizedBox(h:12)
      - "Onset time (optional)" overline + time picker button (showTimePicker)
        → Maps to SymptomLog.onset (TimeOfDay?)
      - SizedBox(h:8)
      - "Duration (optional)" overline + Row: hours DropdownButton [0-24] + ":" + minutes DropdownButton [0,15,30,45]
        → Maps to SymptomLog.duration (Duration?)
      - SizedBox(h:12)
      - "Notes (optional)" overline + TextField (zinc900 bg, zinc800 border, 6px radius, hint "Any details..." zinc500)
      - SizedBox(h:12)
      - Row: TextButton "Remove" (LucideIcons.trash2 14px red400 + "Remove" destructive) left +
        Spacer + TextButton "Done" (ghost zinc300) right

  "+ Add" tap → Bottom sheet (BottomSheet from Theme):
    DraggableScrollableSheet or showModalBottomSheet
    zinc900 bg, 12px top radius, drag handle (40×4 zinc700 pill, center)
    Header: "Add Symptoms" h2 zinc50 + LucideIcons.x close button zinc400
    Search input (same style as 1B)
    Category filter chips (same as 1B)
    Symptom grid (same as 1B, but multi-select with check state)
    Footer: "Add Selected (X)" ElevatedButton full-width

- SizedBox(height: 32) — bottom scroll padding

Auto-save indicator (top-right of form, below AppBar):
- AnimatedOpacity "Saving..." micro zinc500, fades in/out on auto-save triggers

INTERACTION STATES:
- Loading (edit mode): Shimmer skeleton for mood section and symptom list
- Empty form: Mood buttons all unselected, intensity hidden, symptom section shows empty state
- Partially filled: Save button enables, Draft button shows
- Unsaved changes + back press: PopScope → AlertDialog "Save as draft?" [Discard / Save Draft]
- Save success: Navigate back + SnackBar "Entry saved ✓" with teal400 leading icon
- Save error: SnackBar "Failed to save. Try again." with red400 leading icon

Flutter specifics:
- ConsumerStatefulWidget with TabController
- journalFormNotifier StateNotifier for all form state
- flutter_animate for mood selection, intensity slide-down, symptom expand
- PopScope for unsaved changes guard
- Timer.periodic(30s) for auto-draft save
```

---

## ❌ SCREEN 3C: JOURNAL ENTRY FORM — Sleep & Medications Tab

> **Status:** ❌ Belum dikerjakan — widget files kosong
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **Widget files (empty):** `lib/presentation/widgets/journal/sleep_input.dart`, `medication_input.dart`
> **Widget API (SleepInput):** `SleepInput({DateTime? bedTime, DateTime? wakeTime, int quality, int disturbances, required callbacks...})`
> **Widget API (MedicationInput):** `MedicationInput({required List<Medication> meds, required List<MedicationLog> logs, required callbacks...})`
> **Domain entities:** `SleepRecord` (bedTime, wakeTime, quality, disturbances, get duration), `MedicationLog` (medicationId, taken, time, dosage)

```
Using the MedMind design system, create journal form Tab 2: Sleep & Medications.

CONTEXT: This is Tab 2 of the JournalEntryPage TabBarView. Same Scaffold, AppBar, and TabBar as Screen 3B.

Widget APIs (child widgets of this tab):
  SleepInput({
    DateTime? bedTime, DateTime? wakeTime,
    int quality,        // 1-10, default 5
    int disturbances,   // 0-20, default 0
    required ValueChanged<DateTime?> onBedTimeChanged,
    required ValueChanged<DateTime?> onWakeTimeChanged,
    required ValueChanged<int> onQualityChanged,
    required ValueChanged<int> onDisturbancesChanged,
  }) — StatelessWidget

  MedicationInput({
    required List<Medication> medications,
    required List<MedicationLog> logs,
    required ValueChanged<MedicationLog> onLogUpdated,
    required VoidCallback onManageMeds,
  }) — StatelessWidget

[Tab 2 Content] — SingleChildScrollView, Padding h:16

SLEEP SECTION:
- Overline: "SLEEP LAST NIGHT"
- SizedBox(height: 12)

- SleepInput widget (file: sleep_input.dart):
  [Time pickers] — Row of 2, gap: 12
    Each: Expanded Container zinc900 bg, zinc800 border, 12px radius, 16px padding
    GestureDetector → showTimePicker (themed via DatePickerTheme)
    ⚠️ NOTE: SleepRecord entity uses DateTime (not TimeOfDay). Convert: DateTime(date.year, date.month, date.day, pickedTime.hour, pickedTime.minute)
    Column center:
      label overline zinc400 ("Bedtime" / "Wake Time")
      SizedBox(h:8),
      Row: LucideIcons.clock (16px teal400) + SizedBox(w:8) +
        time monoMedium (24px/700 zinc50) e.g. "11:30 PM"

  - SizedBox(height: 12)
  - Duration pill (auto-calculated from bedTime & wakeTime):
    Center: Container teal500_20 bg, 1px teal500 border, 999px radius, padding h:12 v:6
    Row: LucideIcons.moon (14px teal400) + SizedBox(w:6) + duration monoSmall teal400 "7h 30m"
    Shows "—" if times not set

  - SizedBox(height: 16)
  - Health Connect import row (if HealthConnect available):
    Container zinc900 bg, zinc800 border, 8px radius, padding h:12 v:10
    Row: HC logo (14px icon or Text "HC" mono teal400) + SizedBox(w:8) +
      "Import from Health Connect" body zinc300 + Spacer +
      LucideIcons.refreshCw (16px zinc400) spin animation while syncing
    Tap → call HealthConnectChannel.readSleepSessions

  - SizedBox(height: 16)
  - Sleep Quality: Row "Quality" overline zinc400 + Spacer + value monoSmall "8/10"
    SizedBox(h:8), Slider (teal400 active, zinc700 inactive, min 1, max 10, divisions 9)

  - SizedBox(height: 16)
  - Disturbances stepper: Row [
      "Woke up" overline zinc400 + Spacer +
      IconButton LucideIcons.minus (zinc900 bg, zinc800 border, 28px, zinc400 icon) +
      SizedBox(w:12) + "2 times" bodyMedium zinc50 (monoSmall for number) +
      SizedBox(w:12) + IconButton LucideIcons.plus (zinc900 bg, zinc800 border, 28px, zinc400 icon)
    ]
    Min 0, max 20. teal400 icon color when value > 0 for plus.

- SizedBox(height: 32)

MEDICATIONS SECTION:
- Row: Overline "MEDICATIONS" left + TextButton "Manage" ghost zinc400 right → navigate /settings (medication config)
- SizedBox(height: 12)

- MedicationInput widget (file: medication_input.dart):
  IF medications list empty:
    Container zinc900 bg, zinc800 border dashed, 8px radius, padding 16
    Row: LucideIcons.pill (20px zinc500) + SizedBox(w:8) +
      Column(start) [ "No medications set up" body zinc400, "Add in Settings →" accentSmall teal400 ]

  IF medications exist — Column, gap: 4
    Each medication row: Container zinc900 bg, zinc800 border, 8px radius, padding h:16 v:12
    Row:
      LucideIcons.pill (16px zinc400) + SizedBox(w:12) +
      Expanded Column(start) [
        med name bodyMedium (14px/500 zinc50),
        dosage + frequency caption zinc400 (e.g. "500mg • Daily")
        → Maps to Medication.dosage + Medication.frequency
      ] +
      Switch (teal when taken/true, zinc700 when not taken/false)

    Expanded state (tap row): AnimatedContainer 200ms
      - SizedBox(h:12) + Divider zinc800
      - "Time taken" overline + time picker button
      - "Dosage override" overline + TextField for custom dose
      - SizedBox(h:8)

  - SizedBox(height: 16)
  - TextButton "+ Log PRN medication" ghost (teal400, LucideIcons.plus 14px)
    → opens small bottom sheet to search/add one-time medication

- SizedBox(height: 32) — bottom padding

INTERACTION STATES:
- Default: No times set (shows "-- : --" placeholder in time pickers), quality slider at 5, disturbances at 0
- HC import loading: refreshCw icon spins, import text says "Importing..."
- HC import success: Times auto-fill, brief green check flash, SnackBar "Sleep data imported"
- HC import error: SnackBar "Could not import. Enter manually."
- HC unavailable: import row hidden entirely
- Loading (edit mode): Shimmer skeleton for time pickers + quality slider + medication list
- Error (med load): Medication section shows MedMindErrorWidget compact + "Retry"
- Empty (no meds): Dashed border card with "No medications set up" + "Add in Settings →" link

Flutter specifics:
- Child widgets of JournalEntryPage TabBarView — not a standalone page
- SleepInput: StatelessWidget with callbacks to parent form notifier
- MedicationInput: StatelessWidget with Switch toggles, callbacks to parent
- showTimePicker from Flutter Material (themed via app_theme.dart)
- HealthConnectChannel.readSleepSessions() for HC import
- Duration auto-calculated: wakeTime.difference(bedTime)
```

---

## ❌ SCREEN 3D: JOURNAL ENTRY FORM — Lifestyle & Notes Tab

> **Status:** ❌ Belum dikerjakan — widget file kosong
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **Widget file (empty):** `lib/presentation/widgets/journal/free_text_input.dart`
> **Widget API (FreeTextInput):** `FreeTextInput({String? initialText, required ValueChanged<String> onChanged})`
> **Domain entities:** `LifestyleFactorLog` (factorId, boolValue?, numericValue?, scaleValue?), `FactorType` enum

```
Using the MedMind design system, create journal form Tab 3: Lifestyle & Notes.

CONTEXT: Tab 3 of JournalEntryPage TabBarView.

Widget API (child widget):
  FreeTextInput({
    String? initialText,
    required ValueChanged<String> onChanged,
  }) — StatelessWidget

[Tab 3 Content] — SingleChildScrollView, Padding h:16

LIFESTYLE FACTORS SECTION:
- Overline: "LIFESTYLE TODAY"
- SizedBox(height: 12)

Three types of factor inputs rendered dynamically from LifestyleFactor entities:

[Boolean factors] — toggle row
Each: Container zinc900 bg, zinc800 border, 8px radius, padding h:16 v:10
Row: emoji Text (16px) + SizedBox(w:8) + factor name body zinc50 + Spacer + Switch (teal/zinc700)
Examples: "Caffeine ☕", "Alcohol 🍷", "Smoking 🚬", "Supplements 💊"
Gap between rows: 4px

[Numeric factors] — input row
Each: Container zinc900 bg, zinc800 border, 8px radius, padding h:16 v:10
Row: emoji (16px) + SizedBox(w:8) + factor name body zinc50 + Spacer +
  [quantity input: Container 48px wide, zinc800 bg, zinc700 border, 6px radius, center-aligned monoSmall teal400] +
  SizedBox(w:6) + unit label caption zinc400
Examples: "Water 💧 [8] glasses", "Exercise 🏃 [30] minutes"
Tap input → keyboard with number type

[Scale factors] — compact slider row
Each: Container zinc900 bg, zinc800 border, 8px radius, padding h:16 v:10
Column: Row [ factor name + emoji body zinc50, Spacer, value monoSmall zinc50 "6/10" ]
  SizedBox(h:8)
  SliderTheme: teal400 active, zinc700 inactive, 4px track height (compact), 16px thumb
Examples: "Stress Level 😤: 6/10", "Energy Level ⚡: 7/10"

- SizedBox(height: 12) between different factor type groups
- SizedBox(height: 32)

FREE TEXT SECTION:
- Row: Overline "NOTES" left + Spacer + word count "0 words" mutedCaption zinc500 right
- SizedBox(height: 12)

- FreeTextInput widget (file: free_text_input.dart):
  Container: zinc900 bg, 1px zinc800 border, 12px radius
  TextField:
    minLines: 5, maxLines: null (auto-expand)
    padding: 16
    style: body (14px/400 zinc50), height: 1.6
    hint: "How are you feeling? Any triggers or observations?" zinc600 italic
    keyboardType: multiline

- SizedBox(height: 16)

[NLP Suggestion Banner] — shown AFTER save, if NLP extracts symptoms from text (Phase 4 future feature)
- AnimatedContainer slide-up 300ms
- Container: amber900_20 bg, left border 2px amber500, 8px radius, padding 12
- Row: LucideIcons.sparkles (16px amber400) + SizedBox(w:8) +
  Expanded: "We noticed you mentioned headache and fatigue. Add to symptoms?" small zinc300
- Row below: TextButton "Add" accentSmall teal400 + TextButton "Dismiss" ghost zinc400 right
- Future feature — render only when ExtractedSymptom data is available

- SizedBox(height: 32)

ACTIVITY LEVEL SECTION (compact):
- Overline: "ACTIVITY LEVEL"
- SizedBox(height: 12)
- Row of 4 icon buttons (from ActivityLevel enum: sedentary, light, moderate, active), equal flex, gap: 6
  Each: Container zinc800 bg, 8px radius, padding v:10
  Column center: icon (20px zinc400), SizedBox(h:4), label micro zinc500
    sedentary: LucideIcons.sofa "Sedentary"
    light: LucideIcons.footprints "Light"
    moderate: LucideIcons.bike "Moderate"
    active: LucideIcons.flame "Active"
  Selected: teal500_20 bg, teal400 icon, teal400 label

- SizedBox(height: 32) — bottom padding

INTERACTION STATES:
- Default: All toggles OFF, numeric fields empty, scale sliders at 5, text area empty, no activity selected
- Loading (edit mode): Shimmer for factor rows + text area placeholder
- Empty: Not applicable — factors always shown (pre-configured during onboarding)
- Error: Not applicable — all data is local, no remote fetch
- Success: Handled by parent JournalEntryPage save flow (SnackBar "Entry saved ✓")
- All factors are optional — form can be saved without any lifestyle data
- Word count updates live as user types

Flutter specifics:
- Child widgets of JournalEntryPage TabBarView — not a standalone page
- FreeTextInput: StatelessWidget with TextEditingController from parent
- Lifestyle factor rows: dynamically render boolean/numeric/scale based on FactorType
- Word count: TextEditingController.text.split(RegExp(r'\s+')).length
- ActivityLevel enum → Row of 4 selectable icon buttons
- NLP Suggestion Banner: Phase 4 future — conditionally shown when ExtractedSymptom available
```

---

## ❌ SCREEN 4A: INSIGHTS OVERVIEW PAGE

> **Status:** ❌ Belum dikerjakan — stub "Insights" text
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/insights/insights_page.dart` (17 LOC — needs full rewrite)
> **Widget API:** `InsightsPage({Key? key})` — `ConsumerStatefulWidget`
> **State:** `tabController (TabController)`, `selectedPeriod (DateRange)`
> **Providers watched:** `insightReportProvider`, `healthScoreProvider`, `correlationResultsProvider`
> **Child widgets:** `HealthScoreRing`, `InsightCard`, `CorrelationHeatmap`
> **Widget files needed (create new):**
>
> - `lib/presentation/widgets/home/health_score_ring.dart` (empty, 0 bytes)
> - `lib/presentation/widgets/insights/insight_card.dart` (new)
> - `lib/presentation/widgets/insights/correlation_heatmap.dart` (new)
>
> **Domain entities:** `Insight`, `CorrelationResult`, `HealthScore`, `InsightType` enum, `ScoreTrend` enum

```
Using the MedMind design system, create the Insights overview page.

Page: InsightsPage({Key? key}) — ConsumerStatefulWidget
State: tabController (TabController, 3 tabs), selectedPeriod (DateRange)
Watches: insightReportProvider → InsightReport, healthScoreProvider → HealthScore,
         correlationResultsProvider → List<CorrelationResult>
Children: HealthScoreRing, InsightCard, CorrelationHeatmap (inline below)

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- Bottom nav visible
- Body: SafeArea

[Header] — Padding(h: 16, top: 8)
- Row: "Insights" AppTypography.h1 (24px/600 zinc50) + Spacer +
  TextButton: "Last 30 days ▾" ghost zinc400 (LucideIcons.calendar 14px before text)
  → tap opens period selector bottom sheet (7 days, 30 days, 90 days, All time)

[Health Score Card] — Padding(h: 16), SizedBox(height: 16)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 20px padding

  Row: [
    HealthScoreRing widget: 120px size (see Component prompt below)
  ] + SizedBox(w:20) + [
    Expanded Column(start):
      trend Row: LucideIcons.trendingUp (16px teal400) + SizedBox(w:6) +
        "↑ 4" accentSmall teal400 + SizedBox(w:4) + "vs last week" mutedCaption zinc500
      SizedBox(h:12),
      3 sub-score rows, gap:6:
        Each: Row [ dot (6px circle, color) + SizedBox(w:8) + label caption zinc400 + Spacer + value captionMedium zinc50 ]
        "Sleep" dot:teal400 value:"8.2"
        "Mood" dot:cyan400 value:"6.5"
        "Symptoms" dot:indigo400 value:"7.1"
  ]

  SizedBox(h:16) + Divider 1px zinc800 + SizedBox(h:12),
  trend description: small (13px) zinc400 italic "Improving steadily — sleep quality driving gains"

[Tab Bar] — below card
- TabBar: "Insights" | "Correlations" | "Timeline"
- Same style as journal form tabs: teal400 active underline, zinc400 inactive

═══ TAB: INSIGHTS ═══

NOT ENOUGH DATA STATE (< 14 journal entries):
- Centered column in TabBarView:
  LucideIcons.lock (40px teal400) + SizedBox(h:16) +
  "Build your baseline" h2 zinc50 + SizedBox(h:8) +
  "Journal for 14 days to unlock AI insights." muted zinc400 + SizedBox(h:24) +
  Progress bar: Container full-width, 6px height, zinc800 bg, 999px radius
    Inner: teal400 fill proportional to (entryCount / 14), 999px radius
  SizedBox(h:8) + "Day 9 of 14" caption zinc400 + SizedBox(h:4) + "5 more days to go 🔑" caption zinc400

NORMAL STATE (≥ 14 entries):
- ListView.builder of InsightCard widgets, padding h:16, gap: 8

  InsightCard (file: insight_card.dart):
  Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding

  Top Row: type badge pill left + "87%" monoSmall zinc500 right (confidence)
    Badge colors (by InsightType):
      correlation: teal500_20 bg, teal400 text "Correlation"
      anomaly: amber900_20 bg, amber400 text "Anomaly"
      trend: indigo900_50 bg, indigo400 text "Trend"
      recommendation: purple900_50 bg, purple400 text "Recommendation"

  SizedBox(h:8)
  Title: h3 (16px/600 zinc50) — e.g. "Sleep Duration → Migraine Risk"
    Unread: zinc50 (bold feel), Read: zinc300

  SizedBox(h:4)
  Body: small (13px/400 zinc300), maxLines: 3, height: 1.6
    e.g. "You're 2.8× more likely to experience migraines after sleeping fewer than 6 hours. Observed across 23 instances."

  SizedBox(h:12)
  Supporting mini-chart (inline): Container height: 40
    For correlation: 2-bar comparison (Row of 2 bars: teal400 vs zinc700, proportional height, labels below)
    For anomaly: single spike red400 bar among zinc700 baseline bars
    For trend: sparkline (CustomPaint) 3-month teal400 line on zinc800 bg

  Divider 1px zinc800 + SizedBox(h:8)
  Footer Row: "Based on 31 days" mutedCaption zinc500 left + Spacer +
    IconButton LucideIcons.bookmark (16px, zinc400 when unsaved, teal400 filled when saved)

  Expanded state (tap card): AnimatedContainer 300ms
    Full description text body zinc300 height: 1.6
    SizedBox(h:12)
    "What you can do:" h3 zinc50 + bullet list (small zinc300):
      - "Track your sleep more consistently"
      - "Avoid caffeine after 3 PM"
    SizedBox(h:12)
    TextButton "Dismiss" ghost zinc400

  Press state: Container with zinc800 bg briefly (100ms)

═══ TAB: CORRELATIONS ═══
- Padding 16
- "Variable Correlation Matrix" overline + LucideIcons.helpCircle (14px zinc500) right → tooltip explaining heatmap

- CorrelationHeatmap widget (file: correlation_heatmap.dart):
  CustomPaint based widget:
  - Canvas size: NxN grid where N = number of tracked variables (typically 5-12)
  - Cell size: calculated from available width / (N+1)
  - Background track: zinc800
  - Cell colors: interpolated based on correlation coefficient:
    Positive: zinc900 (0) → teal500 (1.0)
    Negative: zinc900 (0) → red500 (-1.0)
  - Cell text: coefficient "0.72" monoSmall zinc50, or "-0.45" monoSmall
  - Row/Column labels: 10px Inter zinc400, rotated 45° for columns
  - Selected cell: 2px zinc50 border ring

  InteractiveViewer wrapping for pinch-to-zoom when > 8 variables

  Tap cell → tooltip card (Container zinc800 bg, 8px radius, 12px padding):
    "Sleep Quality × Mood Score" bodyMedium zinc50
    "r = 0.72, p < 0.01" monoSmall teal400
    → Maps to CorrelationResult.correlationCoefficient + .pValue
    "28 data points, lag: 0d" captionMedium zinc400
    → Maps to CorrelationResult.sampleSize + .lag (lag in days, 0 = same-day)

═══ TAB: TIMELINE ═══
  (Simplified initial implementation — full CustomPainter timeline deferred)
- Horizontal SingleChildScrollView
- Date axis: Row of day columns (44px wide), today at right end
- 3-5 horizontal track rows (collapsible):
  Each track: Row header (label 11px zinc500, 60px wide) + colored bar/dot per day
    Sleep: Container per day, height proportional to hours, teal400
    Mood: emoji or colored dot per day
    Symptom count: number badge per day, colored by severity
    Caffeine: small icon (☕) per day if consumed
- Today marker: vertical dashed line teal400 1px
- Track label left side: LucideIcons.chevronDown to collapse/expand

Minimum: render a date strip + 2 tracks (sleep bars + mood dots) as proof of concept.

INTERACTION STATES:
- Loading: HealthScoreRing shows dashed circle zinc700, shimmer inside card, shimmer for 2 insight cards
- Empty (no analysis yet): Health Score shows "--" placeholder, insight tab shows "not enough data" state
- Error: Card with error message + LucideIcons.alertTriangle + "Retry" button
- Success: New insight generated → badge count on Insights tab, card animates in (slideInUp 300ms)
- Stale data: subtle banner "Last analyzed 2 days ago. Tap to refresh." zinc400 with LucideIcons.refreshCw

Flutter specifics:
- ConsumerStatefulWidget with TabController (3 tabs: Insights, Correlations, Timeline)
- insightReportProvider for insight list + healthScoreProvider for score
- correlationResultsProvider for heatmap data
- Period selector: showModalBottomSheet with 4 date range options
- CorrelationHeatmap: CustomPainter + InteractiveViewer for zoom
- Timeline: horizontal SingleChildScrollView + CustomPaint for track bars
```

---

## ❌ SCREEN 5A: SETTINGS PAGE

> **Status:** ❌ Belum dikerjakan — stub + all sub-pages are stubs
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **Files:**
>
> - `lib/presentation/pages/settings/settings_page.dart` (17 LOC — needs full rewrite)
> - `lib/presentation/pages/settings/reminder_settings_page.dart` (16 LOC — stub)
> - `lib/presentation/pages/settings/secutiry_settings_page.dart` (16 LOC — stub, NOTE: filename has typo)
> - `lib/presentation/pages/settings/health_connect_settings_page.dart` (16 LOC — stub)
> - `lib/presentation/pages/settings/export_page.dart` (16 LOC — stub)
>
> **Widget API:** `SettingsPage({Key? key})` — `ConsumerWidget`
> **Providers watched:** `userPreferencesProvider`, `biometricStateProvider`, `encryptionStatusProvider`
> **Route:** `/settings` with sub-routes `/settings/security`, `/settings/reminders`, `/settings/health-connect`, `/settings/export`

```
Using the MedMind design system, create the Settings page.

Page: SettingsPage({Key? key}) — ConsumerWidget
Watches: userPreferencesProvider → UserPreferences, biometricStateProvider → bool,
         encryptionStatusProvider → EncryptionStatus
Platform: KeystoreChannel.destroyKey() (Delete All Data flow)

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- Bottom nav visible
- Body: SafeArea + SingleChildScrollView + Padding(h: 16)

[Header] — center
- SizedBox(height: 8), "Settings" AppTypography.h1 (24px/600 zinc50)
- SizedBox(height: 24)

[Profile Section] — first card
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Row:
  CircleAvatar 48px (zinc700 bg, zinc300 initials text bodyMedium — first letter of name or "M" default) +
  SizedBox(w:12) +
  Expanded Column(start) [
    "Your Name" h3 (16px/600 zinc50) — or "MedMind User" default
    SizedBox(h:2),
    "Edit Profile" accentSmall teal400
  ] +
  LucideIcons.chevronRight (16px zinc500)
- Tap → future profile page (not yet implemented — show SnackBar "Coming soon")

- SizedBox(height: 24)

[Settings Sections] — each section:
Group label: Overline (12px/500 zinc400 letterSpacing 0.8) + SizedBox(h:8)
Card: Container zinc900 bg, 1px zinc800 border, 12px radius

Each setting row inside card:
  InkWell → Padding h:16 v:14
  Row: icon (20px zinc400) + SizedBox(w:12) + Expanded Column(start) [
    label body (14px/400 zinc50),
    if subtitle: SizedBox(h:2) + subtitle caption zinc400
  ] + trailing element + SizedBox(w:4) + LucideIcons.chevronRight (16px zinc500) if navigable
  Divider 1px zinc800 between rows (not top, not bottom)

Section "Data & Privacy":
- LucideIcons.shield | "Encryption Status" | trailing: "AES-256 Active" accentSmall teal400 | chevron → /settings/security
- LucideIcons.key | "Change Biometric Lock" | trailing: Switch (current state) | no chevron
- LucideIcons.database | "Health Connect Sync" | trailing: Switch | tap → /settings/health-connect
- LucideIcons.download | "Export My Data" | subtitle: "PDF or CSV" | chevron → /settings/export

Section "Tracking":
- LucideIcons.activity | "Manage Symptoms" | trailing: "12 tracked" caption zinc400 | chevron → symptom management
- LucideIcons.pill | "Manage Medications" | trailing: "3 tracked" caption zinc400 | chevron → medication management
- LucideIcons.zap | "Manage Lifestyle Factors" | trailing: "6 tracked" caption zinc400 | chevron → factor management
- LucideIcons.bell | "Reminders" | trailing: "Daily at 9:00 PM" caption zinc400 | chevron → /settings/reminders

Section "Appearance":
- LucideIcons.moon | "Theme" | trailing: SegmentedButton (zinc900 bg):
    "System" | "Light" | "Dark" — active segment: teal500_20 bg, teal400 text, 1px teal500 border
    (Note: currently dark mode only — System and Light disabled/zinc700 with tooltip "Coming soon")

Section "About":
- LucideIcons.info | "Version" | trailing: "1.0.0 (1)" monoSmall zinc500 | no chevron
- LucideIcons.fileText | "Privacy Policy" | chevron → opens URL
- LucideIcons.trash2 (red400) | "Delete All Data" (destructive style: red500 text) | no chevron, no trailing

- SizedBox(height: 24)

[Danger Zone] — separate card
- Container: zinc900 bg, 1px red500 alpha 0.3 border, 12px radius, 16px padding
- "Delete All Data" h3 red500
- SizedBox(h:8)
- Text: "This permanently destroys your encryption key, making all data unrecoverable. This cannot be undone." small zinc400 height: 1.5
- SizedBox(h:16)
- Full-width button: Container red500 bg, 6px radius, 44px height, center "Delete Everything" body zinc50
- Tap → 2-step confirmation:
  Step 1: AlertDialog "Are you sure?" + "This will delete all journal entries, insights, and your encryption key." + [Cancel / Delete]
  Step 2: Type "DELETE" TextField confirmation
  On confirm → KeystoreChannel.destroyKey() + clear Isar + navigate to onboarding

- SizedBox(height: 32) — bottom padding

INTERACTION STATES:
- Default: All settings show current values from UserPreferencesRepository
- Loading: Settings values show small shimmer placeholder
- Toggle change: Immediate visual feedback + save to preferences async
- Empty: Not applicable — settings page always has structure
- Error on save: SnackBar "Failed to save setting. Try again."
- Success (delete all): Navigate to onboarding after 2-step confirmation + key destruction

Flutter specifics:
- ConsumerWidget — mostly reads providers, minimal local state
- userPreferencesProvider for all toggle states and values
- biometricStateProvider for biometric switch
- KeystoreChannel.destroyKey() for "Delete All Data" flow
- showDialog for 2-step delete confirmation (AlertDialog + TextField confirm)
- Theme segmented button: currently disabled for System/Light (dark only)
```

---

## ❌ SCREEN 5B: SECURITY SETTINGS PAGE

> **Status:** ❌ Belum dikerjakan — file stub (16 LOC)
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/settings/secutiry_settings_page.dart` (16 LOC — stub, ⚠️ typo di filename: "secutiry")
> **Widget:** `SecuritySettingsPage` → rewrite as `ConsumerWidget`
> **Widget API:** `SecuritySettingsPage({Key? key})` — `ConsumerWidget`
> **Providers watched:** `encryptionStatusProvider`, `biometricStateProvider`, `keystoreNotifier`
> **Route:** `/settings/security` (sudah ada di `app_router.dart`)
> **Platform:** `KeystoreChannel` (193 LOC — sudah implemented)
> **Domain:** `UserPreferencesRepository` untuk simpan biometric preferences

```
Using the MedMind design system, create the Security Settings detail page.

Page: SecuritySettingsPage({Key? key}) — ConsumerWidget
Watches: encryptionStatusProvider → EncryptionStatus, biometricStateProvider → bool,
         keystoreNotifier → KeystoreState
Platform: KeystoreChannel (biometric check, key rotation)

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- No bottom nav (pushed route, not tab)
- AppBar: back arrow left, "Security" h2 center

[Body] — SafeArea + SingleChildScrollView + Padding(h: 16)

[Encryption Status Card] — SizedBox(height: 16)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Row: LucideIcons.shieldCheck (24px teal400) + SizedBox(w:12) + Expanded Column(start) [
    "Encryption Active" h3 zinc50,
    SizedBox(h:4),
    "AES-256-GCM field-level encryption" caption zinc400,
    SizedBox(h:4),
    "Key stored in Android Keystore" caption zinc400
  ]
- SizedBox(h:16) + Divider 1px zinc800 + SizedBox(h:12)
- Row: "Key ID" caption zinc500 left + Spacer + key fingerprint monoSmall zinc300 "●●●●-AB3F" (truncated)
- SizedBox(h:8)
- Row: "Created" caption zinc500 left + Spacer + date caption zinc300 "Mar 1, 2026"

[Biometric Lock Card] — SizedBox(height: 16)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Row: LucideIcons.fingerprint (20px teal400) + SizedBox(w:12) + Expanded Column(start) [
    "Biometric Lock" bodyMedium zinc50,
    SizedBox(h:2),
    "Require fingerprint to open app" caption zinc400
  ] + Switch (teal when ON, zinc700 when OFF)
- AnimatedContainer (200ms) → visible when biometric ON:
  SizedBox(h:12) + Divider zinc800 + SizedBox(h:12)
  Row: "Auto-lock after" body zinc50 + Spacer + DropdownButton "5 minutes"
    Options: 1 min, 5 min, 15 min, 30 min
    Style: zinc900 bg, zinc800 border, 6px radius, body zinc300

[Data Integrity Card] — SizedBox(height: 16)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Column:
  - Row: LucideIcons.database (20px zinc400) + SizedBox(w:12) + "Data Integrity Check" bodyMedium zinc50
  - SizedBox(h:12)
  - Row: "Last verified" caption zinc500 + Spacer + "Today, 2:30 PM" caption zinc300
  - SizedBox(h:8)
  - Row: "Journal entries" caption zinc500 + Spacer + "142 encrypted" caption zinc300
  - SizedBox(h:16)
  - Full-width OutlinedButton: "Run Integrity Check" (zinc800 border, zinc300 text, LucideIcons.refreshCw 14px)
    Loading state: CircularProgressIndicator(size:14, teal400) replaces icon
    Success: SnackBar "All entries verified ✓"

[Rotate Key Section] — SizedBox(height: 24)
- Container: zinc900 bg, 1px amber500 alpha 0.3 border, 12px radius, 16px padding
- Row: LucideIcons.keyRound (20px amber400) + SizedBox(w:12) + Expanded Column(start) [
    "Rotate Encryption Key" bodyMedium zinc50,
    SizedBox(h:4),
    "Re-encrypt all data with a new key. This may take a few minutes." small zinc400 height:1.5
  ]
- SizedBox(h:16)
- Full-width OutlinedButton: "Rotate Key" (amber400 text, amber500 alpha 0.3 border)
- Tap → AlertDialog confirmation: "This will re-encrypt all entries. Continue?" [Cancel / Rotate]
- Progress: LinearProgressIndicator (teal400) + "Re-encrypting entry 42 of 142..." caption zinc400

- SizedBox(height: 32) — bottom padding

INTERACTION STATES:
- Default: Encryption active (always), biometric based on saved preference
- Biometric toggle ON: calls KeystoreChannel for biometric auth & auto-lock card slides in
- Biometric toggle ERROR (no hardware): SnackBar "Biometric not available on this device" + switch reverts
- Loading: Brief shimmer for key ID and created date fields
- Integrity check running: button shows spinner, text changes to "Checking..."
- Integrity check success: SnackBar "All entries verified ✓" (teal400 icon)
- Key rotation: AlertDialog → LinearProgressIndicator → success SnackBar "Key rotated successfully"
- Error (rotation fail): SnackBar "Key rotation failed. Data unchanged." red400

Flutter specifics:
- ConsumerWidget — reads encryptionStatusProvider + biometricStateProvider
- KeystoreChannel for biometric check + key rotation
- AnimatedContainer for auto-lock card slide-in (200ms)
- showDialog for key rotation confirmation
- LinearProgressIndicator during rotation (determinate, tracks entry count)
```

---

## ❌ SCREEN 5C: REMINDER SETTINGS PAGE

> **Status:** ❌ Belum dikerjakan — file stub (16 LOC)
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/settings/reminder_settings_page.dart` (16 LOC — stub)
> **Widget:** `ReminderSettingsPage` → rewrite as `ConsumerStatefulWidget`
> **Widget API:** `ReminderSettingsPage({Key? key})` — `ConsumerStatefulWidget`
> **State:** `reminderEnabled (bool)`, `reminderTime (TimeOfDay)`, `activeDays (Set<int>)`, `streakProtection (bool)`, `smartSuggestions (bool)`
> **Providers watched:** `reminderPreferencesProvider` (belum ada)
> **Route:** `/settings/reminders` (sudah ada di `app_router.dart`)

```
Using the MedMind design system, create the Reminder Settings page.

Page: ReminderSettingsPage({Key? key}) — ConsumerStatefulWidget
State: reminderEnabled (bool), reminderTime (TimeOfDay), activeDays (Set<int>),
       streakProtection (bool), smartSuggestions (bool)
Watches: reminderPreferencesProvider → ReminderPreferences

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- No bottom nav (pushed route)
- AppBar: back arrow left, "Reminders" h2 center

[Body] — SafeArea + SingleChildScrollView + Padding(h: 16)

[Master Toggle] — SizedBox(height: 16)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Row: LucideIcons.bell (20px teal400) + SizedBox(w:12) + Expanded Column(start) [
    "Daily Journal Reminder" bodyMedium zinc50,
    SizedBox(h:2),
    "Get notified to log your daily entry" caption zinc400
  ] + Switch (teal/zinc700)

[Reminder Time] — AnimatedContainer (200ms, visible when master toggle ON)
- SizedBox(height: 12)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Row: LucideIcons.clock (20px zinc400) + SizedBox(w:12) + "Reminder Time" body zinc50 + Spacer +
  GestureDetector → showTimePicker:
    time text monoMedium (24px/700 teal400) "9:00 PM" + LucideIcons.chevronDown (14px zinc500)

[Days of Week] — SizedBox(height: 12)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- "Active Days" overline zinc400
- SizedBox(h:12)
- Row of 7 day toggles, MainAxisAlignment.spaceEvenly
  Each: GestureDetector → Container 36×36, borderRadius 999px (circle)
    Label: "M" "T" "W" "T" "F" "S" "S" — captionMedium
    Active: teal500_20 bg, teal400 text, 1px teal500 border
    Inactive: zinc800 bg, zinc500 text, 1px zinc800 border
  Default: all active (daily)

[Streak Reminder] — SizedBox(height: 12)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Row: LucideIcons.flame (20px orange400) + SizedBox(w:12) + Expanded Column(start) [
    "Streak Protection" bodyMedium zinc50,
    SizedBox(h:2),
    "Extra reminder 2h before midnight if you haven't logged" caption zinc400
  ] + Switch (teal/zinc700)

[Smart Suggestions] — SizedBox(height: 12)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- Row: LucideIcons.sparkles (20px teal400) + SizedBox(w:12) + Expanded Column(start) [
    "Smart Log Suggestions" bodyMedium zinc50,
    SizedBox(h:2),
    "Show quick-log prompt in notification" caption zinc400
  ] + Switch (teal/zinc700)

[Preview Card] — SizedBox(height: 24)
- Overline "NOTIFICATION PREVIEW" + SizedBox(h:8)
- Container: zinc800 bg, 1px zinc700 border, 12px radius, 16px padding
  Simulated notification card:
  Row: LucideIcons.brain (16px teal400) + SizedBox(w:8) + "MedMind" captionMedium zinc50 + Spacer + "9:00 PM" micro zinc500
  SizedBox(h:8)
  "Time for your daily check-in" bodyMedium zinc50
  SizedBox(h:4)
  "How are you feeling? Tap to log." small zinc400

- SizedBox(height: 32) — bottom padding

INTERACTION STATES:
- Default: Reminder ON, 9:00 PM, all days active, streak protection ON
- Loading: Shimmer for time display + day toggles
- Master OFF: time/days/streak sections hidden with AnimatedContainer (200ms ease-out)
- Empty: Not applicable — always has default values
- Error on save: SnackBar "Failed to save reminder settings. Try again."
- Success on save: Implicit — visual toggle feedback is immediate
- Permission denied: SnackBar "Enable notifications in system settings" + deeplink to app settings

Flutter specifics:
- ConsumerStatefulWidget — local state for all toggle/time values
- reminderPreferencesProvider to read/write preferences
- showTimePicker for reminder time selection
- AnimatedContainer for master toggle show/hide animation
- flutter_local_notifications integration (future) for scheduling
- AppSettings.openAppSettings() for notification permission deeplink
```

---

## ❌ SCREEN 5D: HEALTH CONNECT SETTINGS PAGE

> **Status:** ❌ Belum dikerjakan — file stub (16 LOC)
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/settings/health_connect_settings_page.dart` (16 LOC — stub)
> **Widget:** `HealthConnectSettingsPage` → rewrite as `ConsumerStatefulWidget`
> **Widget API:** `HealthConnectSettingsPage({Key? key})` — `ConsumerStatefulWidget`
> **State:** `permissionStates (Map<String, bool>)`, `syncFrequency`, `isSyncing (bool)`
> **Providers watched:** `healthConnectStatusProvider`, `syncHistoryProvider` (belum ada)
> **Route:** `/settings/health-connect` (sudah ada di `app_router.dart`)
> **Platform:** `HealthConnectChannel` (243 LOC — sudah implemented)

```
Using the MedMind design system, create the Health Connect Settings page.

Page: HealthConnectSettingsPage({Key? key}) — ConsumerStatefulWidget
State: permissionStates (Map<String, bool>), syncFrequency (SyncFrequency), isSyncing (bool)
Watches: healthConnectStatusProvider → HCStatus, syncHistoryProvider → List<SyncEvent>
Platform: HealthConnectChannel (permissions, sync, read)

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- No bottom nav (pushed route)
- AppBar: back arrow left, "Health Connect" h2 center

[Body] — SafeArea + SingleChildScrollView + Padding(h: 16)

[Status Banner] — SizedBox(height: 16)
- IF Health Connect installed & connected:
  Container: teal500_10 bg, 1px teal500 alpha 0.3 border, 12px radius, 16px padding
  Row: LucideIcons.checkCircle (20px teal400) + SizedBox(w:12) + Expanded Column(start) [
    "Connected" bodyMedium teal400,
    SizedBox(h:2),
    "Last synced: Today, 8:30 AM" caption zinc400
  ] + TextButton "Sync Now" accentSmall teal400 (LucideIcons.refreshCw 14px)

- IF Health Connect NOT installed:
  Container: amber900_20 bg, 1px amber500 alpha 0.3 border, 12px radius, 16px padding
  Row: LucideIcons.alertTriangle (20px amber400) + SizedBox(w:8) + Expanded Column(start) [
    "Health Connect not found" bodyMedium amber400,
    SizedBox(h:4),
    "Install Health Connect from Play Store to sync health data." small zinc400
  ]
  SizedBox(h:12)
  Full-width OutlinedButton: "Install Health Connect" (amber400 text, amber500 alpha 0.3 border, LucideIcons.externalLink 14px)
  → opens Play Store deeplink

[Data Permissions] — SizedBox(height: 24)
- Overline "DATA PERMISSIONS" + SizedBox(h:8)
- Container: zinc900 bg, 1px zinc800 border, 12px radius

Each permission row: InkWell → Padding h:16 v:14
  Row: category icon (20px zinc400) + SizedBox(w:12) + Expanded Column(start) [
    data type body zinc50,
    SizedBox(h:2),
    "Read access" caption zinc400 OR "Not authorized" caption red400
  ] + Switch (teal/zinc700)
  Divider 1px zinc800 between rows

Permissions:
- LucideIcons.moon | "Sleep Sessions" | subtitle: last read date or "Not synced yet"
- LucideIcons.heart | "Heart Rate" | subtitle: "Resting + active"
- LucideIcons.footprints | "Steps" | subtitle: daily count
- LucideIcons.activity | "Exercise Sessions" | subtitle: workout types
- LucideIcons.scale | "Weight" | subtitle: last measurement

Toggle ON → call HealthConnectChannel.requestPermission(dataType)
Toggle OFF → call HealthConnectChannel.revokePermission(dataType)

[Sync Settings] — SizedBox(height: 24)
- Overline "SYNC SETTINGS" + SizedBox(h:8)
- Container: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding

- Row: "Auto-sync frequency" body zinc50 + Spacer +
  DropdownButton: "Every 6 hours" (options: Manual, Every hour, Every 6 hours, Daily)
  Style: zinc900 bg, zinc800 border, 6px radius
- SizedBox(h:12) + Divider zinc800 + SizedBox(h:12)
- Row: "Sync on app open" body zinc50 + Spacer + Switch (teal/zinc700)
- SizedBox(h:12) + Divider zinc800 + SizedBox(h:12)
- Row: "Background sync" body zinc50 + Spacer + Switch (teal/zinc700)
  SizedBox(h:4) + "Requires notification permission" caption zinc500

[Sync History] — SizedBox(height: 24)
- Overline "RECENT SYNC HISTORY" + SizedBox(h:8)
- Column of last 5 sync events, gap: 4:
  Each: Container zinc900 bg, zinc800 border, 8px radius, padding h:12 v:8
  Row: status icon (14px, teal400 check or red400 x) + SizedBox(w:8) +
    Expanded Column(start) [
      "Sleep data synced" captionMedium zinc300,
      "Today, 8:30 AM • 2 records" micro zinc500
    ]

- SizedBox(height: 32) — bottom padding

INTERACTION STATES:
- Default: Connected state with current permissions
- HC not installed: Warning banner with Play Store link, all toggles disabled (zinc700)
- Syncing: "Sync Now" button shows spin animation (LucideIcons.refreshCw spin), text "Syncing..."
- Loading: Shimmer for permission rows + sync history
- Empty (no sync history): "No sync events yet" caption zinc500
- Sync success: SnackBar "Data synced ✓" + sync history updated
- Sync error: SnackBar "Sync failed: permission denied" red400 + retry
- Permission denied (system): SnackBar "Open Health Connect to grant access" + deeplink button

Flutter specifics:
- ConsumerStatefulWidget — tracks permission states + sync status
- healthConnectStatusProvider to check HC install status
- HealthConnectChannel for all HC API calls (permissions, sync, read)
- syncHistoryProvider for recent sync events
- android_intent_plus or url_launcher for Play Store deeplink
- AnimatedList for sync history entries
```

---

## ❌ SCREEN 5E: EXPORT DATA PAGE

> **Status:** ❌ Belum dikerjakan — file stub (16 LOC)
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/pages/settings/export_page.dart` (16 LOC — stub)
> **Widget:** `ExportPage` → rewrite as `ConsumerStatefulWidget`
> **Widget API:** `ExportPage({Key? key})` — `ConsumerStatefulWidget`
> **State:** `selectedFormat (ExportFormat)`, `dateRange`, `selectedDataTypes (Set)`, `exportState (idle/exporting/done/error)`
> **Providers watched:** `journalCountProvider`, `exportNotifier` (belum ada)
> **Route:** `/settings/export` (sudah ada di `app_router.dart`)

```
Using the MedMind design system, create the Export Data page.

Page: ExportPage({Key? key}) — ConsumerStatefulWidget
State: selectedFormat (ExportFormat), dateRange (DateTimeRange),
       selectedDataTypes (Set<DataType>), exportState (idle | exporting | done | error)
Watches: journalCountProvider → DataCounts, exportNotifier → ExportState

STRUCTURE:
- Scaffold bg: AppColors.zinc950
- No bottom nav (pushed route)
- AppBar: back arrow left, "Export Data" h2 center

[Body] — SafeArea + SingleChildScrollView + Padding(h: 16)

[Header Info] — SizedBox(height: 16)
- Container: zinc900 bg, left border 2px teal500, 12px radius, 16px padding
- Row: LucideIcons.shieldCheck (16px teal400) + SizedBox(w:12) + Expanded Text:
  "Your exported data is encrypted. Only you can read it with your encryption key." small zinc400 height:1.5

[Export Format Selection] — SizedBox(height: 24)
- Overline "EXPORT FORMAT" + SizedBox(h:12)
- Row of 2 cards, gap: 12, each Expanded:

  Card 1 — PDF Report:
  GestureDetector → Container zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
  Column center:
    LucideIcons.fileText (28px zinc400) + SizedBox(h:8) +
    "PDF Report" bodyMedium zinc50 + SizedBox(h:4) +
    "Summary + charts" caption zinc400
  Selected: teal500_20 bg, 1px teal500 border, teal400 icon

  Card 2 — CSV Data:
  Same layout:
    LucideIcons.table (28px zinc400) + SizedBox(h:8) +
    "CSV Data" bodyMedium zinc50 + SizedBox(h:4) +
    "Raw data, importable" caption zinc400
  Selected: teal500_20 bg, 1px teal500 border, teal400 icon

[Date Range] — SizedBox(height: 24)
- Overline "DATE RANGE" + SizedBox(h:12)
- 4 pill chips horizontal, gap:8, SingleChildScrollView:
  "Last 7 days" | "Last 30 days" | "Last 90 days" | "All time"
  Active: teal500_20 bg, teal400 text, 1px teal500 border, 999px radius
  Inactive: zinc900 bg, zinc500 text, 1px zinc800 border, 999px radius
  Caption medium (12px/500)

- SizedBox(height: 12)
- Custom range row: Container zinc900 bg, zinc800 border, 8px radius, padding h:12 v:10
  Row: LucideIcons.calendar (16px zinc400) + SizedBox(w:8) +
    "Custom: " caption zinc400 + start date zinc300 + " — " + end date zinc300
    + Spacer + LucideIcons.chevronRight (14px zinc500)
  Tap → showDateRangePicker

[Data Selection] — SizedBox(height: 24)
- Overline "INCLUDE DATA" + SizedBox(h:12)
- Container: zinc900 bg, 1px zinc800 border, 12px radius

Each row: Padding h:16 v:12
  Row: checkbox (Checkbox teal400 active, zinc700 inactive) + SizedBox(w:12) +
    Expanded Column(start) [
      data type body zinc50,
      count caption zinc400
    ]
  Divider 1px zinc800

Rows:
- ☑ "Journal Entries" — "142 entries"
- ☑ "Symptoms & Severity" — "428 symptom logs"
- ☑ "Sleep Records" — "98 records"
- ☑ "Medication Logs" — "215 logs"
- ☑ "Lifestyle Factors" — "567 factor logs"
- ☑ "AI Insights" — "23 insights"
Default: all checked

[Export Preview] — SizedBox(height: 24)
- Container: zinc800 bg, 12px radius, 16px padding
- "Preview" overline zinc400 + SizedBox(h:8)
- "📊 142 journal entries" small zinc300
- "📅 Mar 1 — Mar 8, 2026" small zinc300
- "📦 Estimated size: ~2.4 MB" small zinc300
- "🔒 Encrypted: Yes" small teal400

[Export Button] — SizedBox(height: 24)
- Full-width ElevatedButton: "Export to PDF" or "Export to CSV" (teal500 bg, zinc50 text, 48px height)
  Icon: LucideIcons.download (20px) before text

[Export Progress] — replaces button when exporting
- LinearProgressIndicator (teal400 active, zinc800 track)
- SizedBox(h:8) + "Exporting entry 42 of 142..." caption zinc400 center
- TextButton "Cancel" ghost zinc400

[Export Complete] — after success
- Container: teal500_10 bg, 1px teal500 alpha 0.3 border, 12px radius, 16px padding
- Row: LucideIcons.checkCircle (20px teal400) + SizedBox(w:12) + Expanded Column(start) [
    "Export Complete" bodyMedium teal400,
    SizedBox(h:4),
    "medmind_export_2026-03-08.pdf" monoSmall zinc300
  ]
- SizedBox(h:12)
- Row gap:12: Expanded OutlinedButton "Share" (LucideIcons.share2 14px, zinc300 text, zinc800 border)
  + Expanded OutlinedButton "Save to Files" (LucideIcons.folderDown 14px, zinc300 text, zinc800 border)
→ Uses Share.shareXFiles (share_plus) or file_picker for save location

- SizedBox(height: 32) — bottom padding

INTERACTION STATES:
- Default: PDF selected, "All time" range, all data checked
- Exporting: Button → progress bar + cancel option
- Export complete: Success card with share/save buttons
- Loading: Shimmer for data count rows (fetching entry/log counts)
- Export error: SnackBar "Export failed: [reason]" red400 + "Try again" action
- Empty data: "No data in selected range" muted zinc400 + export button disabled

Flutter specifics:
- ConsumerStatefulWidget with export state machine (idle → exporting → done/error)
- exportNotifier: StateNotifier managing progress (entryIndex / totalEntries)
- journalCountProvider for data stats in preview card
- showDateRangePicker for custom date range selection
- Share.shareXFiles (share_plus) for sharing exported file
- PDF generation: pdf package or custom CSV writer
```

---

## ❌ COMPONENT: HEALTH SCORE RING

> **Status:** Belum dikerjakan — file kosong
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/widgets/home/health_score_ring.dart` (0 bytes)
> **Used in:** Home Dashboard (80px), Insights page (120px)
> **Domain entity:** `HealthScore` (overallScore: 0-100, trend: ScoreTrend enum)
> **Colors:** `AppColors.scoreGradientCritical/Poor/Good/Excellent`

```
Using the MedMind design system, design and implement a HealthScoreRing widget using CustomPainter.

Widget API:
  HealthScoreRing({
    required double score,         // 0-100
    required ScoreTrend trend,     // improving, stable, declining
    double size = 100,             // small: 64, medium: 100, large: 140
    bool showLabel = true,
    bool animate = true,
  })

CustomPainter — HealthScoreRingPainter:

  [Background ring]
  - strokeWidth: size * 0.12 (proportional)
  - color: AppColors.zinc800
  - strokeCap: StrokeCap.round
  - Full 360° arc

  [Score arc]
  - Same strokeWidth
  - Gradient sweep: SweepGradient from score color pair
    0-30:   scoreGradientCritical (red500 → orange500)
    31-60:  scoreGradientPoor (orange500 → yellow #FACC15)
    61-80:  scoreGradientGood (teal400 → cyan300)
    81-100: scoreGradientExcellent (teal400 → emerald300)
  - Start angle: -pi/2 (12 o'clock position), clockwise
  - Sweep angle: (score / 100) * 2 * pi
  - StrokeCap.round

  [Glow effect at arc endpoint]
  - Paint with MaskFilter.blur(BlurStyle.normal, 6)
  - Color: arc end color with 0.4 alpha
  - Small circle (radius: strokeWidth * 0.8) at arc endpoint

  [Center content] (as child of CustomPaint, not painted):
  - Column center:
    score number: AppTypography.monoLarge (36px/700) for large, monoMedium (24px/700) for medium
    SizedBox(h:2),
    "Score" AppTypography.micro (11px zinc500) — only if showLabel true

  [Trend indicator] (below ring, outside CustomPaint):
  - Row center:
    trend icon (14px):
      improving: LucideIcons.trendingUp teal400
      stable: LucideIcons.minus zinc400
      declining: LucideIcons.trendingDown red400
    SizedBox(w:4),
    "↑ 4" / "→ 0" / "↓ 3" accentSmall / mutedCaption / destructive

Animation:
- AnimationController: duration 1500ms
- CurvedAnimation: Curves.easeOutCubic
- Tween<double>(begin: 0, end: score)
- AnimatedBuilder wraps CustomPaint
- Score number counts up smoothly during animation

Sizes reference:
- Small (64px):  strokeWidth ~8, score text monoMedium, no "Score" label
- Medium (100px): strokeWidth ~12, score text monoMedium, "Score" label
- Large (140px):  strokeWidth ~14, score text monoLarge, "Score" label, extra glow

Flutter specifics:
- StatefulWidget with SingleTickerProviderStateMixin
- didUpdateWidget: if score changed, animate from old to new value
- Semantics wrapper: "Health score {score} out of 100, {trend}" for accessibility
```

---

## ❌ COMPONENT: MOOD PICKER (Standalone Reference)

> **Status:** Belum dikerjakan — file kosong
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/widgets/journal/mood_picker.dart`
> **Used in:** Journal Entry Form Tab 1 (Screen 3B)
> **Enum:** `Mood` (great, good, okay, bad, terrible)

```
Using the MedMind design system, design a MoodPicker widget.

Widget API:
  MoodPicker({
    Mood? selectedMood,
    int? intensity,         // 1-10
    required ValueChanged<Mood> onMoodSelected,
    required ValueChanged<int> onIntensityChanged,
  })

[Mood Buttons Row] — Row of 5, MainAxisAlignment.spaceEvenly, gap: 8
Each button:
  GestureDetector → AnimatedContainer 200ms ease-out
  Width: (screenWidth - 32 - 32) / 5 (account for padding and gaps)
  Padding v:8

  Column center:
    emoji Text size: 24
    SizedBox(h:6),
    label AppTypography.micro (11px)

  States per mood (from Mood enum):
    great 😊:
      default:  zinc900 bg, zinc800 border
      selected: emerald900_30 bg, emerald400 1px border, emerald400 label color
    good 🙂:
      default:  zinc900 bg, zinc800 border
      selected: teal500_20 bg, teal500 1px border, teal400 label color
    okay 😐:
      default:  zinc900 bg, zinc800 border
      selected: Color(0x4D3F3F46) bg, zinc500 1px border, zinc300 label color
    bad 😟:
      default:  zinc900 bg, zinc800 border
      selected: orange900_30 bg, orange400 1px border, orange400 label color
    terrible 😰:
      default:  zinc900 bg, zinc800 border
      selected: red900_20 bg, red400 1px border, red400 label color

  Unselected label color: zinc500
  Tap: scale 0.95 → 1.05 → 1.0 (spring, 200ms, flutter_animate .scale)
  BorderRadius: 10px
  Border width: 1px

[Intensity Slider] — AnimatedCrossFade 300ms ease-out
  Visible: only when selectedMood != null
  Hidden: SizedBox.shrink()

  SizedBox(height: 16),
  Row: "Intensity" AppTypography.overline zinc400 + Spacer + value AppTypography.monoSmall zinc50 "${intensity}/10"
  SizedBox(height: 8),
  Slider:
    min: 1, max: 10, divisions: 9
    value: intensity ?? 5 (default)
    activeColor: mood-specific color (same as selected border color)
    inactiveColor: AppColors.zinc700
    Theme: SliderThemeData with:
      trackHeight: 6
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)
      thumbColor: Colors.white with 2px border of mood color (via overlay)

Flutter specifics:
- StatelessWidget (state managed by parent via callbacks)
- flutter_animate for tap spring effect
- Semantics: "Mood: {mood}, intensity {value} out of 10"
```

---

## ❌ COMPONENT: INSIGHT CARD

> **Status:** Belum dikerjakan — no file exists yet
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File to create:** `lib/presentation/widgets/insights/insight_card.dart`
> **Used in:** Insights page (Screen 4A), Home dashboard (preview)
> **Domain entity:** `Insight` (type, title, description, confidence, isRead, isSaved)

```
Using the MedMind design system, design a reusable InsightCard widget.

Widget API:
  InsightCard({
    required Insight insight,
    bool isExpanded = false,
    required VoidCallback onTap,
    required VoidCallback onBookmarkToggle,
  })

[Container]
- zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
- GestureDetector onTap → toggles expanded state
- Press feedback: zinc800 bg briefly (100ms via AnimatedContainer)

[Top Row]
- Row: InsightTypeBadge left + Spacer + confidence monoSmall zinc500 "92%"
- InsightTypeBadge: Container 4px radius, padding h:8 v:4
  correlation:    teal500_20 bg, teal400 text "Correlation"
  anomaly:        amber900_20 bg, amber400 text "Anomaly"
  trend:          indigo900_50 bg, indigo400 text "Trend"
  recommendation: purple900_50 bg, purple400 text "Tip"
  Text: captionMedium (12px/500)

[Title] — SizedBox(h:8)
- Text: h3 (16px/600)
- Unread: zinc50 color
- Read: zinc300 color
- maxLines: 1, overflow ellipsis

[Body] — SizedBox(h:4)
- Text: small (13px/400 zinc300), maxLines: 3, height: 1.6, overflow ellipsis

[Mini Chart] (inline, optional, depends on insight type)
SizedBox(h:12),
Container height: 40
- For correlation: Row of 2 bars (height proportional), teal400 vs zinc700, labels below (caption zinc500)
- For anomaly: Row of small bars (zinc700), one spike bar (red400)
- For trend: CustomPaint sparkline (teal400, 1.5px stroke), small dots, zinc800 bg

[Footer] — SizedBox(h:8), Divider 1px zinc800, SizedBox(h:8)
- Row: "Based on X days" mutedCaption zinc500 left + Spacer +
  IconButton LucideIcons.bookmark (16px):
    unsaved: zinc400 (outline)
    saved: teal400 (filled — LucideIcons.bookmarkCheck or filled variant)

[Expanded Content] — AnimatedContainer 300ms ease-out
- Visible only when isExpanded == true
- SizedBox(h:12), Divider 1px zinc800, SizedBox(h:12)
- Full description: body zinc300, height: 1.6
- SizedBox(h:16)
- "What you can do:" h3 zinc50 + SizedBox(h:8) +
  Bullet list: each Row [ "•" teal400, SizedBox(w:8), Text small zinc300 ]
- SizedBox(h:12)
- TextButton "Dismiss" ghost zinc400

Compact variant (for Home preview):
- Narrower (260px wide), maxLines body: 2, no mini chart, no footer, no expand
```

---

## ❌ COMPONENT: SYMPTOM CHIP (Logged)

> **Status:** ❌ Belum dikerjakan — file belum ada
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File to create:** `lib/presentation/widgets/journal/symptom_chip_card.dart`
> **Used in:** Journal Form (Screen 3B), Journal List Card (Screen 3A)

```
Using the MedMind design system, design a SymptomChipCard widget (collapsible).

Widget API:
  SymptomChipCard({
    required String symptomName,
    required int severity,        // 1-10
    TimeOfDay? onset,             // → SymptomLog.onset
    Duration? duration,           // → SymptomLog.duration
    String? notes,
    bool isExpanded = false,
    required VoidCallback onTap,
    required ValueChanged<int> onSeverityChanged,
    required ValueChanged<TimeOfDay?> onOnsetChanged,
    required ValueChanged<Duration?> onDurationChanged,
    required ValueChanged<String?> onNotesChanged,
    required VoidCallback onRemove,
  })

[Collapsed State]
- Container: full-width, zinc900 bg, 1px zinc800 border, 8px radius, padding h:16 v:12
- Row:
  symptom name AppTypography.bodyMedium (14px/500 zinc50) +
  Spacer +
  severity badge pill: Container 4px radius, padding h:8 v:4
    Colors by severity range (from AppColors):
      1-3:  emerald400 text, emerald900_30 bg, text: "Low • {value}"
      4-6:  amber400 text, amber900_20 bg, text: "Mod • {value}"
      7-8:  orange400 text, orange900_30 bg, text: "High • {value}"
      9-10: red400 text, red900_20 bg, text: "Severe • {value}"
    Text: captionMedium (12px/500)
  SizedBox(w:8) +
  LucideIcons.chevronDown (16px zinc500) — rotates 180° when expanded

[Expanded State] — AnimatedContainer 300ms ease-out, maxHeight 0→200
- Divider 1px zinc800, SizedBox(h:12)
- "Severity" overline zinc400 + Spacer + value monoSmall zinc50 "{severity}/10"
- SizedBox(h:8)
- Slider: active color = severity color gradient (emerald → amber → orange → red based on value), inactive zinc700
- SizedBox(h:12)
- "Notes (optional)" overline zinc400
- SizedBox(h:6)
- TextField: zinc900 bg, zinc800 border, 6px radius, hint "Any details..." zinc500, body zinc50, minLines:1 maxLines:3
- SizedBox(h:12)
- Row: TextButton "Remove" (LucideIcons.trash2 14px + "Remove" destructive red500) left +
  Spacer + TextButton "Done" (ghost, zinc300) right onTap → collapse

Animation: smooth expand/collapse via AnimatedContainer. Chevron icon rotates (AnimatedRotation).
List of SymptomChipCards: Column with 4px gap, AnimatedList for add/remove transitions.
```

---

## ❌ COMPONENT: QUICK LOG BUTTONS

> **Status:** Belum dikerjakan — file kosong
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/widgets/home/quick_log_buttons.dart` (0 bytes)
> **Used in:** Home Dashboard (Screen 2A)

```
Using the MedMind design system, design a QuickLogButtons widget row.

Widget API:
  QuickLogButtons({
    required VoidCallback onLogMood,
    required VoidCallback onLogSymptom,
    required VoidCallback onAddNote,
  })

Layout: Row of 3, MainAxisAlignment.spaceEvenly, gap: 8, each Expanded

Each button:
  GestureDetector → Container:
    zinc900 bg, 1px zinc800 border, 8px radius, 12px padding
    Column mainAxisAlignment.center:
      icon (20px teal400) + SizedBox(h:8) + label (AppTypography.caption zinc300)

  Press state: zinc800 bg briefly (100ms), scale 0.97 (flutter_animate, 100ms)
  Hover/focus: 1px teal500 alpha 0.3 border

Buttons:
  1. LucideIcons.smile → "Log Mood" → calls onLogMood (navigate /journal/new?tab=mood)
  2. LucideIcons.plus → "Log Symptom" → calls onLogSymptom (navigate /journal/new?tab=symptom)
  3. LucideIcons.fileText → "Add Note" → calls onAddNote (navigate /journal/new?tab=notes)

Flutter specifics:
- StatelessWidget (callbacks from parent)
- Semantics: "Quick log: {label}" on each button
- Min height: 72px per button for 44px tap target compliance
```

---

## ❌ COMPONENT: DAILY SUMMARY CARD

> **Status:** Belum dikerjakan — file ada tapi TANPA extension `.dart`
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah
> **File:** `lib/presentation/widgets/home/daily_summary_card` (0 bytes — ⚠️ rename ke `daily_summary_card.dart`)
> **Used in:** Home Dashboard (Screen 2A) — "Today's Summary Card" section
> **Domain entities:** `JournalEntry`, `HealthScore`

```
Using the MedMind design system, design a DailySummaryCard widget.

Widget API:
  DailySummaryCard({
    JournalEntry? todayEntry,
    HealthScore? score,
    required VoidCallback onLogEntry,
    required VoidCallback onViewEntry,
  })

[Container]
- zinc900 bg, 1px zinc800 border, 12px radius, 16px padding

[Header Row]
- Row: "Today's Health" AppTypography.overline (12px/500 zinc400 letterSpacing:0.8) left +
  Spacer + TextButton "Log Entry" ghost (accentSmall teal400) + LucideIcons.plus (14px teal400)

IF todayEntry != null:
  - SizedBox(height: 16)
  - Row: [HealthScoreRing(score: score?.overallScore ?? 0, size: 80, trend: score?.trend)] +
    SizedBox(w:16) + Expanded Column [
      score display: "${score}" monoMedium + " Score" caption zinc500,
      SizedBox(h:4),
      trend indicator row
    ]
  - SizedBox(height: 16)
  - Row of 3 stat chips (equal flex):
    Each: Container zinc800 bg, 8px radius, 8px padding
    Column center: icon (16px zinc400) + SizedBox(h:4) + value (captionMedium zinc300) + SizedBox(h:2) + label (micro zinc500)
    Sleep: LucideIcons.moon + duration + "Sleep"
    Symptoms: LucideIcons.activity + count + "Symptoms"
    Mood: emoji 16px + mood label + "Mood"
  - Divider 1px zinc800, SizedBox(h:12)
  - "Last logged: Today, {time}" micro zinc500
  - GestureDetector onTap → onViewEntry

IF todayEntry == null:
  - SizedBox(height: 24)
  - Center Column:
    LucideIcons.plusCircle (32px teal400) + SizedBox(h:12) +
    "No entry yet today" bodyMedium zinc300 + SizedBox(h:4) +
    "Tap to start logging" mutedCaption zinc500
  - SizedBox(height: 24)
  - GestureDetector onTap → onLogEntry

Flutter specifics:
- StatelessWidget (data from parent via providers)
- Null-safe: handle missing entry and missing score gracefully
- Semantics: "Today's health summary. Score {x} out of 100" or "No entry logged today. Tap to create."
```

---

## SHARED UTILITY WIDGETS

> **Status:** ❌ Empty files, both need implementation
> **Accessibility:** ⬜ Belum diverifikasi — lihat ACCESSIBILITY CHECKLIST di bawah

### Loading Indicator

> **File:** `lib/presentation/shared/loading_indicator.dart` (0 bytes)
> **Accessibility:** ⬜ Belum diverifikasi — min tap target 44px, Semantics label required

```
Create a reusable MedMindLoadingIndicator widget in two variants:

1. Circular: SizedBox(24×24) CircularProgressIndicator(strokeWidth: 2, color: AppColors.teal400, backgroundColor: AppColors.zinc800)

2. Shimmer card: Container zinc900 bg, 12px radius, specified height.
   ShaderMask with LinearGradient(colors: [zinc800, zinc700, zinc800]) animating left→right, 1.5s loop.
   Used for skeleton placeholders.

Widget API:
  MedMindLoading.circular({double size = 24})
  MedMindLoading.shimmer({required double height, double? width, double radius = 12})
```

### Error Widget

> **File:** `lib/presentation/shared/error_widget.dart` (0 bytes)
> **Accessibility:** ⬜ Belum diverifikasi — retry button min 44px, error message via Semantics.liveRegion

```
Create a reusable MedMindErrorWidget:

Widget API:
  MedMindErrorWidget({
    required String message,
    VoidCallback? onRetry,
    bool compact = false,
  })

Full variant (compact: false):
- Center Column:
  LucideIcons.alertTriangle (32px, red400) +
  SizedBox(h:12) + message h3 (16px/600 zinc300) textAlign center +
  SizedBox(h:8) + "Something went wrong" muted zinc400 +
  if onRetry: SizedBox(h:16) + OutlinedButton "Try Again" (zinc800 border, zinc300 text, LucideIcons.refreshCw 14px)

Compact variant (compact: true):
- Row: LucideIcons.alertTriangle (16px red400) + SizedBox(w:8) +
  Expanded(message small zinc400) +
  if onRetry: TextButton "Retry" accentSmall teal400
```

---

## FULL APP FLOW PROMPT (for v0.dev / Figma AI)

> **⚠️ PERHATIAN:** Prompt ini KHUSUS untuk generate mockup/preview visual di tools
> seperti v0.dev, Figma AI, atau Midjourney. **BUKAN** untuk implementasi Flutter langsung.
> Untuk implementasi Flutter, gunakan prompt per-screen individual di atas.
>
> Gunakan prompt ini untuk generate preview lengkap dari semua screen MedMind dalam satu mockup.

```
Create a complete mobile app UI mockup for "MedMind", a private health journaling app with 4 main screens on bottom navigation.

Design system: Dark mode. Background #09090B, cards #18181B, borders #27272A, primary text #FAFAFA, muted #71717A, accent teal #14B8A6. Font: Inter. Style: shadcn/ui inspired, minimal, data-dense. Lucide icons. 390px mobile width. 12px card radius.

Screen 1 — HOME: Greeting + date top. Summary card with health score ring (animated circular progress 0-100, gradient arc), mood/sleep/symptom stats below. Streak counter "🔥 7-day streak". 3 quick-log ghost cards (Log Mood, Log Symptom, Add Note). Horizontal-scrolling insight preview cards with type badges.

Screen 2 — JOURNAL: H1 "Journal" + search/filter icons. Pill tab filters (All/This Week/This Month/Drafts). Stacked entry cards showing: date, mood emoji + intensity bar, symptom severity chips, sleep duration, free text snippet. FAB for new entry. Entry form has 3 tabs: Mood & Symptoms (emoji picker + expandable symptom chips), Sleep & Meds (time pickers + med toggles), Lifestyle & Notes (toggle/numeric/scale inputs + textarea).

Screen 3 — INSIGHTS: Prominent health score ring (120px, gradient, animated). Sub-scores panel. Tab bar: Insights (ranked insight cards with type badges + confidence + mini-charts) | Correlations (heatmap grid) | Timeline (horizontal scrolling tracks). "Not enough data" state for < 14 days: progress bar with lock icon.

Screen 4 — SETTINGS: Grouped rows for Privacy (encryption status, biometric, Health Connect, export), Tracking (symptoms, meds, lifestyle, reminders), Appearance (theme), About (version, privacy policy). Danger zone: "Delete All Data" with red border + confirmation flow.

Show all 4 screens with bottom navigation (Home/Journal/Insights/Settings, teal active state with pill highlight).
```

---

## ACCESSIBILITY CHECKLIST

> Verifikasi ini sebelum setiap screen dianggap selesai.

```
For each screen, ensure:
1. Minimum tap target 44×44px (all buttons, icons, chips, toggle areas)
2. Color contrast ≥ 4.5:1 body text on dark bg (zinc50 on zinc950 = 19.4:1 ✓)
3. Semantic labels: Semantics(label: "...") on all icon-only buttons
4. CustomPaint widgets: Semantics wrapper with SemanticsProperties(label: "...")
5. Focus order: logical top→bottom, left→right (using FocusTraversalGroup)
6. No info by color alone: always pair color with text/icon (severity chips have text + color)
7. Screen reader: test with TalkBack on Android
```
