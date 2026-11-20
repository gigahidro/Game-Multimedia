# Graph Report - game  (2026-11-20)

## Corpus Check
- Corpus is ~4,836 words - fits in a single context window. You may not need a graph.

## Summary
- 177 nodes · 152 edges · 61 communities (18 shown, 43 thin omitted)
- Extraction: 80% EXTRACTED · 20% INFERRED · 0% AMBIGUOUS · INFERRED: 31 edges (avg confidence: 0.93)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- CT Pillars & Evaluation Tracking
- Audio System & BGM Architecture
- Score & Game State Management
- Instructional Design & Pedagogical Model
- Educational Slides & Materi Navigation
- Level 4 Drag & Drop Mechanics
- Audio System Test Suite
- Level 1 Evaporasi Test Suite
- Level 2 Kondensasi Test Suite
- Level 4 Algoritma Test Suite
- UI Design & Button Standardization
- Interactive Level Gameplay & Sprites
- Level Progression & Unlock Architecture
- Victory Evaluation & Assessment Metrics
- Project Configuration & Engine Settings
- Main Scene Navigation & Exit Flow
- Home Scene Test Suite
- Level 3 Presipitasi Test Suite
- Materi Scene Test Suite
- Main Menu & Level Launcher
- HUD UI Verification Test Suite
- Stealth CT Assessment Philosophy
- Level 2 Kondensasi Gameplay
- Level 3 Presipitasi Gameplay
- Materi Context Navigation Test Suite
- Daftar Aset: Background 1280x7... Component
- Daftar Aset: Tipografi & Font Component
- Automated Test Suite Status (1... Component
- Water Cycle Adventure Project ... Component
- GameOver (Control) Component
- Global (Node Autoload) Component
- Level1.wrong_order_count Component
- Level2.wrong_pattern_attempts Component
- Level3.abstraction_errors Component
- Level4Card (TextureRect Drag S... Component
- Level4Card.process_name Component
- Level4Slot (TextureRect Drop T... Component
- Materi.SLIDES Component
- SkyItem.is_water Component
- SkyItem.item_name Component

## God Nodes (most connected - your core abstractions)
1. `Global.play_sfx()` - 16 edges
2. `Global.play_bgm()` - 10 edges
3. `Global.complete_level()` - 10 edges
4. `Victory._display_ct_evaluation()` - 7 edges
5. `Global.add_score()` - 6 edges
6. `Global.ct_abstraction` - 5 edges
7. `4 Pillars of Computational Thinking Integration` - 5 edges
8. `Four Pillars of Computational Thinking Framework` - 5 edges
9. `Global.current_level` - 4 edges
10. `Global.max_unlocked_level` - 4 edges

## Surprising Connections (you probably didn't know these)
- `Daftar Aset: Audio BGM & SFX` --conceptually_related_to--> `Global.play_sfx()`  [INFERRED]
  DAFTAR_ASET.md → program/scripts/global.gd
- `Full Audio & BGM Architecture` --conceptually_related_to--> `Global.play_sfx()`  [INFERRED]
  HANDOVER_SESSION.md → program/scripts/global.gd
- `Implicit CT Assessment & Evaluation Metric` --conceptually_related_to--> `Test Victory & Evaluation Suite`  [INFERRED]
  Kelompok 14B Template Rencana Media Prak Multimedia 2 - 2026 .docx.pdf → program/tests/test_victory_gameover.gd
- `Daftar Aset: Audio BGM & SFX` --conceptually_related_to--> `Global.play_bgm()`  [INFERRED]
  DAFTAR_ASET.md → program/scripts/global.gd
- `Full Audio & BGM Architecture` --conceptually_related_to--> `Global.play_bgm()`  [INFERRED]
  HANDOVER_SESSION.md → program/scripts/global.gd

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Computational Thinking 4 Pillars Assessment Flow** — program_scripts_level_1_class, program_scripts_level_2_class, program_scripts_level_3_class, program_scripts_level_4_class, program_scripts_victory_class, handover_session_computational_thinking [INFERRED 0.95]
- **Water Cycle Natural Stages (Evaporation to Infiltration)** — program_scripts_level_1_on_evaporation_completed, program_scripts_level_2_on_condensation_completed, program_scripts_level_3_on_precipitation_completed, program_scripts_level_4_on_btn_check_pressed [INFERRED 0.95]
- **Global BGM and Multi-Channel SFX Subsystem** — program_scripts_global_play_sfx, program_scripts_global_play_rain_sfx, program_scripts_global_play_bgm, program_scripts_global_stop_bgm, handover_session_audio_architecture, daftar_aset_audio [INFERRED 0.95]
- **CT Curriculum Alignment across Game Levels** — kelompok_14b_template_rencana_media_prak_multimedia_2_2026_computational_thinking_framework, program_tests_test_level_1_scene_test_decomposition_tracking, program_tests_test_level_2_scene_test_pattern_tracking, program_tests_test_level_3_scene_test_abstraction_distractors, program_tests_test_level_4_scene_test_algorithm_validation, program_tests_test_victory_gameover_test_ct_badges [INFERRED 0.85]
- **Automated Game Scene and System Verification** — program_tests_test_audio_system_suite, program_tests_test_home_scene_suite, program_tests_test_hud_scene_suite, program_tests_test_level_1_scene_suite, program_tests_test_level_2_scene_suite, program_tests_test_level_3_scene_suite, program_tests_test_level_4_scene_suite, program_tests_test_materi_scene_suite, program_tests_test_victory_gameover_suite [EXTRACTED 1.00]

## Communities (61 total, 43 thin omitted)

### Community 0 - "CT Pillars & Evaluation Tracking"
Cohesion: 0.12
Nodes (18): 4 Pillars of Computational Thinking Integration, Global.complete_level(), Global.ct_abstraction, Global.ct_algorithm, Global.ct_decomposition, Global.ct_pattern, Global.play_rain_sfx(), Global.play_sfx() (+10 more)

### Community 1 - "Audio System & BGM Architecture"
Cohesion: 0.26
Nodes (9): Daftar Aset: Audio BGM & SFX, Full Audio & BGM Architecture, Global.current_level, Global.play_bgm(), HUD.update_hud(), Level1._ready(), Level2._ready(), Level3._ready() (+1 more)

### Community 2 - "Score & Game State Management"
Cohesion: 0.22
Nodes (11): GameOver._on_btn_retry_pressed(), GameOver._ready(), Global.add_score(), Global.reset_game(), Global.score, Global.score_changed (signal), Home._on_btn_level1_pressed(), Level1 (Node2D Evaporasi) (+3 more)

### Community 3 - "Instructional Design & Pedagogical Model"
Cohesion: 0.22
Nodes (5): ADDIE Instructional Development Model, Four Pillars of Computational Thinking Framework, Media Plan: Water Cycle Adventure (Kelompok 14B), Target Audience: SD Fase C Elementary Students, Hydrological Water Cycle Educational Curriculum

### Community 4 - "Educational Slides & Materi Navigation"
Cohesion: 0.40
Nodes (5): Global.previous_scene, Home._on_btn_materi_pressed(), HUD._on_btn_materi_pressed(), Materi (Control Slides), Materi._ready()

### Community 5 - "Level 4 Drag & Drop Mechanics"
Cohesion: 0.33
Nodes (4): Level4.on_slot_clicked(), Level4.on_slot_dropped(), Level4.place_card_in_slot(), Level4Slot._drop_data()

### Community 6 - "Audio System Test Suite"
Cohesion: 0.40
Nodes (5): Test Audio System Suite, Audio Playback & Track Transition Test, BGM & Ambience Looping Test, Dedicated Rain SFX Channel Test, Sound Bank 14 Tracks Verification Test

### Community 7 - "Level 1 Evaporasi Test Suite"
Cohesion: 0.40
Nodes (5): Test Level 1 Evaporasi Suite, Level 1 Completion & Next Button Test, Decomposition CT Error Tracking Test, Daytime Transition & Evaporation Progress Test, Level 1 Initial Nighttime State Test

### Community 8 - "Level 2 Kondensasi Test Suite"
Cohesion: 0.40
Nodes (5): Test Level 2 Kondensasi Suite, Level 2 Completion & Blue Knob Test, Atmospheric Cooling & Cloud Formation Test, Pattern Recognition CT Error Tracking Test, Level 2 Initial Warm State & Yellow Knob Test

### Community 9 - "Level 4 Algoritma Test Suite"
Cohesion: 0.40
Nodes (5): Test Level 4 Algoritma Suite, Algorithm Sequence Validation & Penalty Test, Drag-and-Drop Slot Placement & Removal Test, Card Tray Reset Functionality Test, Algorithm Sequence Victory & Scoring Test

### Community 11 - "Interactive Level Gameplay & Sprites"
Cohesion: 0.50
Nodes (3): Daftar Aset: Objek & Sprite Siklus Air, Level4 (Control Algoritma), SkyItem (Area2D)

### Community 12 - "Level Progression & Unlock Architecture"
Cohesion: 0.67
Nodes (3): Progressive Level Locking Architecture, Global.max_unlocked_level, Home._update_level_locks()

### Community 13 - "Victory Evaluation & Assessment Metrics"
Cohesion: 0.50
Nodes (4): Implicit CT Assessment & Evaluation Metric, Test Victory & Evaluation Suite, Overall CT Score Category Calculation Test, Four CT Pillars Evaluation Badges Test

### Community 14 - "Project Configuration & Engine Settings"
Cohesion: 0.50
Nodes (4): Global Autoload Singleton Configuration, Godot Engine Project Configuration, Viewport Display Settings (1280x720 Canvas Items), GL Compatibility Graphics Renderer Settings

### Community 16 - "Home Scene Test Suite"
Cohesion: 0.50
Nodes (4): Test Home Scene Suite, Level Locking & Progression Test, Home Sound Mute Toggle Logic Test, Home Node Structure & Signal Connection Test

### Community 17 - "Level 3 Presipitasi Test Suite"
Cohesion: 0.50
Nodes (4): Test Level 3 Presipitasi Suite, Abstraction Distractor Non-Punitive Tracking Test, Level 3 Rain Activation & Abstraction Scoring Test, Water Droplet Collection & Flight Animation Test

### Community 18 - "Materi Scene Test Suite"
Cohesion: 0.50
Nodes (4): Test Materi Scene Suite, Final Slide Next/Close Replacement Test, Slide Carousel Pagination Test, Materi Sound Mute Toggle Test

### Community 20 - "HUD UI Verification Test Suite"
Cohesion: 0.67
Nodes (3): Test HUD Scene Suite, HUD Safe No-Op API Compatibility Test, Clean Immersive HUD Verification

## Knowledge Gaps
- **59 isolated node(s):** `GameOver (Control)`, `Global (Node Autoload)`, `HUD (CanvasLayer)`, `Level1.wrong_order_count`, `Level2 (Node2D Kondensasi)` (+54 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 110 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **43 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Global.play_sfx()` connect `CT Pillars & Evaluation Tracking` to `Audio System & BGM Architecture`, `Score & Game State Management`, `Level 4 Drag & Drop Mechanics`?**
  _High betweenness centrality (0.086) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Global.play_sfx()` (e.g. with `Daftar Aset: Audio BGM & SFX` and `Full Audio & BGM Architecture`) actually correct?**
  _`Global.play_sfx()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `GameOver (Control)`, `Global (Node Autoload)`, `HUD (CanvasLayer)` to the rest of the system?**
  _59 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `CT Pillars & Evaluation Tracking` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Why does `Global.play_bgm()` connect `Audio System & BGM Architecture` to `CT Pillars & Evaluation Tracking`, `Educational Slides & Materi Navigation`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Global.play_bgm()` (e.g. with `Daftar Aset: Audio BGM & SFX` and `Full Audio & BGM Architecture`) actually correct?**
  _`Global.play_bgm()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Why does `Global.complete_level()` connect `CT Pillars & Evaluation Tracking` to `Level Progression & Unlock Architecture`?**
  _High betweenness centrality (0.034) - this node is a cross-community bridge._