<!-- DESIGN SYSTEM -->

DESIGN SYSTEM — MedMind (Flutter, Material 3, Dark Mode Only)

═══ VIEWPORT ═══
Device: Google Pixel 9 Pro
Screen: 411 × 916pt (logical pixels)
Safe area: top 24pt, bottom 24pt (gesture nav)
Content width: 411pt (full bleed) / 379pt (16pt h-padding each side)
Status bar: 24pt height

═══ COLOR TOKENS (from AppColors) ═══
Background: zinc950 #09090B (Scaffold, body)
Card surface: zinc900 #18181B (Card bg, input bg)
Border: zinc800 #27272A (Card border, dividers, input border)
Subtle: zinc700 #3F3F46 (Disabled border, hover bg)
Muted icon: zinc600 #52525B
Secondary text: zinc500 #71717A (Captions, timestamps, hints)
Muted text: zinc400 #A1A1AA (Subtitles, labels)
Light text: zinc300 #D4D4D8 (Chip text, secondary labels)
Primary text: zinc50 #FAFAFA (Headings, primary text)

Accent: teal500 #14B8A6 (CTA, accent)
Accent hover: teal400 #2DD4BF (Active icons, links)
Accent bg: teal500_10 rgba(20,184,166,0.10) (Active pill bg)
Accent bg med: teal500_20 rgba(20,184,166,0.20) (Selected card bg)

Severity:
Low 1-3: emerald400 #34D399 text, emerald900_30 bg
Moderate 4-6: amber400 #FBBF24 text, amber900_20 bg (also yellow-900)
High 7-8: orange400 #FB923C text, orange900_30 bg
Severe 9-10: red400 #F87171 text, red900_20 bg

Destructive: red500 #EF4444 (Delete buttons, alerts)
Insight types:
Correlation: teal400/teal900 bg
Anomaly: amber400/amber900 bg
Trend: indigo400 #818CF8 / indigo900_50 bg
Recommendation: purple400 #C084FC / purple900_50 bg

Score gradients:
0-30 (critical): red500 → orange500
31-60 (poor): orange500 → yellow #FACC15
61-80 (good): teal400 → cyan300 #67E8F9
81-100 (excellent): teal400 → emerald300 #6EE7B7

═══ TYPOGRAPHY (from AppTypography — Inter + JetBrains Mono) ═══
Display: Inter 32px/700 zinc50
H1: Inter 24px/600 zinc50
H2: Inter 18px/600 zinc50
H3: Inter 16px/600 zinc50
Body Medium: Inter 14px/500 zinc50
Body: Inter 14px/400 zinc50 height:1.5
Small: Inter 13px/400 zinc50 height:1.6
Caption: Inter 12px/400 zinc50 height:1.4
Caption Med: Inter 12px/500 zinc50
Micro: Inter 11px/400 zinc500
Overline: Inter 12px/500 zinc400 letterSpacing:0.8

Muted: Inter 14px/400 zinc400
Muted Small: Inter 13px/400 zinc400
Muted Caption: Inter 12px/400 zinc500

Mono Large: JetBrains Mono 36px/700 zinc50 (health score center)
Mono Medium: JetBrains Mono 24px/700 zinc50 (time displays)
Mono: JetBrains Mono 14px/400 zinc50
Mono Small: JetBrains Mono 12px/400 zinc500 (confidence %)

Accent: Inter 14px/500 teal400
Accent Small: Inter 12px/500 teal400
Destructive: Inter 14px/500 red500

═══ SPACING ═══
4px base grid: 4, 8, 12, 16, 20, 24, 32, 40, 48px
Screen padding: 16px horizontal (or 24px for onboarding)
Card padding: 16px
Section gap: 24px
Inline gap: 8px

═══ COMPONENTS ═══
Card: zinc900 bg, 1px zinc800 border, 12px radius, 16px padding
Input: zinc900 bg, 1px zinc800 border, 6px radius, 14px body text
Button Primary: teal500 bg, zinc50 text, 6px radius, 48px height, full-width
Button Outline: transparent bg, 1px zinc800 border, zinc300 text, 6px radius
Button Ghost: transparent bg, no border, zinc400 text
Button Destructive: red500 bg, zinc50 text
Badge/Chip: 4px radius, 6px h-pad 4px v-pad, 12px text
Pill: 999px radius, zinc900 bg, zinc700 border
Divider: 1px zinc800
Icons: Lucide (from lucide_icons package), 16px or 20px, stroke style

═══ BOTTOM NAV (already implemented — app_bottom_nav.dart) ═══
Height: 52px content + SafeArea bottom
Background: zinc950, border-top 1px zinc800
4 tabs: Home (LucideIcons.home), Journal (bookOpen), Insights (barChart2), Settings (settings)
Active: teal400 icon + teal400 label (11px), teal500_10 bg pill 36×28 6px radius behind icon
Inactive: zinc500 icon + zinc500 label (11px)

═══ INTERACTION STATES ═══
Every screen/component MUST handle:

- Default: Normal content display
- Loading: Shimmer/skeleton placeholder on zinc900 bg
- Empty: Centered illustration + heading zinc50 18px/600 + subtitle zinc400 14px + CTA button
- Error: Red-tinted card or inline message + "Try again" button
- Success: Brief SnackBar confirmation at bottom

<!-- END of DESIGN SYSTEM -->

<!-- 3A Screen section -->

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

<!-- END of 3A Screen section -->

<!-- 3B Screen section -->

Using the MedMind design system, create the Journal Entry Form page with Tab 1: Mood & Symptoms.

Page: JournalEntryPage({Key? key, String? entryId}) — ConsumerStatefulWidget
State: tabController (TabController), form state via journalFormNotifier
Watches: journalFormNotifier → JournalFormState, existingEntryProvider(entryId) → JournalEntry?
Children: MoodPicker, SymptomSelector, SleepInput (Tab 2), MedicationInput (Tab 2), VitalsInput (Tab 3), FreeTextInput (Tab 4)

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

- TabBar with 4 tabs, indicator: teal400 2px underline
- Active tab: accent (14px/500 teal400)
- Inactive tab: muted (14px/400 zinc400)
- Tabs: "Mood & Symptoms" | "Sleep & Meds" | "Vitals" | "Lifestyle & Notes"
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
  good 🙂 — selected: teal500_20 bg, teal500 border
  okay 😐 — selected: zinc700 bg (Color(0x4D3F3F46)), zinc500 border
  bad 😟 — selected: orange900_30 bg, orange400 border
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
  Card expands to show: - SizedBox(h:12) + Divider 1px zinc800 - SizedBox(h:12) - "Severity" overline + value monoSmall right - Slider (severity-colored: emerald → amber → orange → red based on value) - SizedBox(h:12) - "Onset time (optional)" overline + time picker button (showTimePicker)
  → Maps to SymptomLog.onset (TimeOfDay?) - SizedBox(h:8) - "Duration (optional)" overline + Row: hours DropdownButton [0-24] + ":" + minutes DropdownButton [0,15,30,45]
  → Maps to SymptomLog.duration (Duration?) - SizedBox(h:12) - "Notes (optional)" overline + TextField (zinc900 bg, zinc800 border, 6px radius, hint "Any details..." zinc500) - SizedBox(h:12) - Row: TextButton "Remove" (LucideIcons.trash2 14px red400 + "Remove" destructive) left +
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

<!-- END of 3B Screen section -->

<!-- 3C Screen section -->

Using the MedMind design system, create journal form Tab 2: Sleep & Medications.

CONTEXT: This is Tab 2 of the JournalEntryPage TabBarView. Same Scaffold, AppBar, and TabBar as Screen 3B.

Widget APIs (child widgets of this tab):
SleepInput({
DateTime? bedTime, DateTime? wakeTime,
int quality, // 1-10, default 5
int disturbances, // 0-20, default 0
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

  Expanded state (tap row): AnimatedContainer 200ms - SizedBox(h:12) + Divider zinc800 - "Time taken" overline + time picker button - "Dosage override" overline + TextField for custom dose - SizedBox(h:8)
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

<!-- END of 3C Screen section -->

<!-- 3D Screen section -->

Using the MedMind design system, create journal form Tab 4: Lifestyle & Notes.

CONTEXT: Tab 4 of JournalEntryPage TabBarView.

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

<!-- END of 3D Screen section -->

<!-- 3E Screen section -->

Using the MedMind design system, create journal form Tab 3: Vitals.

CONTEXT: Tab 3 of JournalEntryPage TabBarView. Same Scaffold, AppBar, and TabBar as Screen 3B.

Widget API:
VitalsInput({
VitalRecord? initial, // pre-filled in edit mode or after HC import
required bool hcAvailable, // result of HealthConnectChannel.isAvailable()
required VoidCallback onImportAll, // triggers bulk HC import for all metrics
required ValueChanged<VitalRecord> onChanged,
}) — StatelessWidget

Domain entity (create lib/domain/entities/vital_record.dart if it does not exist):
@freezed class VitalRecord {
int? heartRateAvg; // bpm — average over the journaled day
int? heartRateMin; // bpm — minimum reading
int? heartRateMax; // bpm — maximum reading
int? steps; // total steps for the journaled day
double? weightKg; // body weight in kg (manual only — no HC method yet)
int? spO2Percent; // blood oxygen % (manual only — no HC method yet)
}

[Tab 3 Content] — SingleChildScrollView, Padding h:16

HC IMPORT BANNER — shown only when hcAvailable == true:
Container: zinc900 bg, 1px zinc800 border, 8px radius, padding h:12 v:10
Row:
LucideIcons.activity (16px teal400) + SizedBox(w:8) +
Expanded Column(start) [
"Import all vitals from Health Connect" bodyMedium zinc50,
"Last synced: $lastSyncedLabel" caption zinc400
→ $lastSyncedLabel = formatted DateTime or "Never synced"
] +
SizedBox(w:12) +
ElevatedButton "Import" (height 32, padding h:12, teal500 bg)
→ onPressed: onImportAll
→ loading: CircularProgressIndicator 14px white, button disabled

- SizedBox(height: 20)

──────────────────────────────────────────────────────────
HEART RATE SECTION
──────────────────────────────────────────────────────────

- Overline: "HEART RATE" (12px/500 zinc400, letterSpacing 0.8)
- SizedBox(height: 12)

[Metric cards row] — Row of 3, equal flex, gap: 8
Each card: Container zinc900 bg, 1px zinc800 border, 8px radius, padding h:12 v:12
Column(mainAxisSize: min, crossAxisAlignment: center):
label caption (11px zinc500) e.g. "Avg", "Min", "Max"
SizedBox(h:4)
value monoMedium (20px/700):
Avg → zinc50 color
Min → emerald400 color (cooler / lower = good)
Max → orange400 color (higher reading)
Any null → "—" zinc600
unit micro (10px zinc500) "bpm"

- SizedBox(height: 12)

[Per-metric HC sync row] — Container zinc900 bg, zinc800 border, 8px radius, padding h:12 v:8
Visible only when hcAvailable == true
Row:
LucideIcons.refreshCw (14px teal400) + SizedBox(w:6) +
"Sync heart rate from Health Connect" bodySmall zinc400 +
Spacer +
TextButton "Sync" ghost teal400 (height 28, compact)
→ calls HealthConnectChannel.readHeartRate(
startTime: DateTime(date.year, date.month, date.day),
endTime: DateTime(date.year, date.month, date.day, 23, 59, 59))
→ derive avg/min/max from List<HeartRateSample>:
avg = samples.map((s) => s.bpm).reduce(+) ~/ samples.length
min = samples.map((s) => s.bpm).reduce(math.min)
max = samples.map((s) => s.bpm).reduce(math.max)
Loading: LucideIcons.refreshCw spins (flutter_animate RotateEffect), "Syncing..."

- SizedBox(height: 8)
- Center Text "or enter manually" micro zinc600

[Manual input row] — Row of 3, equal flex, gap: 6
Each: Expanded Column(start) [
Text label micro zinc500 ("Avg bpm" / "Min bpm" / "Max bpm"),
SizedBox(h:4),
TextField(
keyboardType: TextInputType.number,
textAlign: TextAlign.center,
style: monoSmall zinc50,
decoration: InputDecoration(
filled: true, fillColor: AppColors.zinc900,
border: OutlineInputBorder(radius 8px, zinc800),
contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
hintText: "—", hintStyle: zinc600),
)
]

- SizedBox(height: 28)

──────────────────────────────────────────────────────────
STEPS SECTION
──────────────────────────────────────────────────────────

- Overline: "STEPS TODAY"
- SizedBox(height: 12)

- Container zinc900 bg, 1px zinc800 border, 8px radius, padding h:16 v:14
  Row:
  LucideIcons.footprints (20px teal400) + SizedBox(w:12) +
  Expanded Column(start) [
  Text(steps?.toString() ?? "—") monoLarge (28px/700 zinc50),
  SizedBox(h:4),
  Row [
  Text("steps") caption zinc400,
  if steps != null && steps! >= 10000 ...
  SizedBox(w:6), Icon(LucideIcons.check, 14px, emerald400),
  Text(" Goal reached!") caption emerald400,
  ]
  ] +
  if hcAvailable:
  TextButton "Sync" ghost teal400 (height 28, compact)
  → calls HealthConnectChannel.readSteps(
  startTime: DateTime(date.year, date.month, date.day),
  endTime: DateTime(date.year, date.month, date.day, 23, 59, 59))

- SizedBox(height: 8)

[Manual input row] — Row [
Text("Manual entry:" micro zinc500), SizedBox(w:8),
Expanded TextField(
keyboardType: TextInputType.number, style: monoSmall zinc50,
decoration: zinc900 bg, zinc800 border, 8px radius,
hint: "0 steps" zinc600),
]

- SizedBox(height: 28)

──────────────────────────────────────────────────────────
BODY WEIGHT SECTION
──────────────────────────────────────────────────────────

- Overline: "BODY WEIGHT"
- SizedBox(height: 12)

- Container zinc900 bg, 1px zinc800 border, 8px radius, padding h:16 v:14
  Row:
  LucideIcons.scale (20px zinc400) + SizedBox(w:12) +
  Expanded Column(start) [
  Row [
  Expanded TextField(
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  style: monoLarge (28px/700 zinc50),
  decoration: InputDecoration(border: InputBorder.none,
  hintText: "—", hintStyle: zinc600),
  ),
  SizedBox(w:8), Text("kg") caption zinc400,
  ],
  SizedBox(h:4),
  Text("Health Connect import not yet available — manual entry only",
  style: micro zinc600, fontStyle: FontStyle.italic),
  ]

  ⚠️ Note: HealthConnectChannel has no readWeight() method yet. Manual entry only.
  When readWeight() is added, follow the same sync row pattern as HEART RATE above.

- SizedBox(height: 28)

──────────────────────────────────────────────────────────
BLOOD OXYGEN (SpO₂) SECTION
──────────────────────────────────────────────────────────

- Overline: "BLOOD OXYGEN (SpO₂)"
- SizedBox(height: 12)

- Container zinc900 bg, 1px zinc800 border, 8px radius, padding h:16 v:14
  Column:
  Row [
  LucideIcons.activity (20px zinc400), SizedBox(w:12),
  Expanded Row [
  Expanded TextField(
  keyboardType: TextInputType.number, style: monoLarge (28px/700 zinc50),
  decoration: InputDecoration(border: InputBorder.none,
  hintText: "—", hintStyle: zinc600),
  ),
  SizedBox(w:6), Text("%") caption zinc400,
  ],
  ],
  SizedBox(h:8),
  Row [
  Container(width: 8, height: 8, radius 999,
  color: spO2 == null ? zinc600
  : spO2! < 94 ? AppColors.red400
  : spO2! < 98 ? AppColors.amber400
  : AppColors.emerald400),
  SizedBox(w:6),
  Text(spO2RangeLabel, style: micro zinc400):
  null → "—"
  < 94 → "Low — please consult a doctor"
  94–97 → "Below normal range"

  > = 98 → "Normal range"
  > ],
  > SizedBox(h:4),
  > Text("Health Connect import not yet available — manual entry only",
  > style: micro zinc600, fontStyle: FontStyle.italic),

  ⚠️ Note: HealthConnectChannel has no readSpO2() method yet. Manual entry only.
  When readSpO2() is added, follow the same sync row pattern as HEART RATE above.

- SizedBox(height: 32) — bottom padding

INTERACTION STATES:

- HC unavailable: import banner hidden; per-metric Sync buttons hidden; all fields manual-only
- HC available, not yet synced: banner shows "Never synced"; all metric values show "—"
- HC importing: banner button enters loading state (spinner + disabled); Sync buttons disabled
- HC import success: metric cards animate number change (flutter_animate, 300ms);
  SnackBar "Vitals imported ✓" teal400 leading icon
- HC import partial — some metrics return no data:
  empty metric shows "—" + Text "No data from Health Connect" micro zinc500 below card
- HC import error: SnackBar "Import failed. Enter manually." red400 leading icon
- Edit mode: VitalRecord fields pre-filled from stored JournalEntry.vitalRecord
- Loading (edit mode): Shimmer for all metric cards and text fields (same shimmer as 3B/3C/3D)
- All fields are optional — form can be saved without any vitals data

Flutter specifics:

- Child widget of JournalEntryPage TabBarView — not a standalone page
- VitalsInput: StatelessWidget with callbacks to parent journalFormNotifier
- hcAvailable: evaluated once at JournalEntryPage initState via HealthConnectChannel.isAvailable()
- HeartRateSample aggregation: import 'dart:math' as math for min/max; avg via integer division
- readSteps() / readHeartRate() date range: midnight-to-now for the journaled date
- Weight and SpO2: manual input only; use double.tryParse() / int.tryParse() — never store 0 as null
- All null VitalRecord fields must stay null, never default to 0

<!-- END of 3E Screen section -->
