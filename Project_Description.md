# Spark Project Documentation 

## Overview
**Spark** is a premium, AI-driven iOS application designed to elevate productivity, challenge assumptions, and foster strategic learning through **Challenge-Based Learning (CBL)**. By integrating a highly analytical and provocative AI Coach (powered by the Groq API running Llama-3.3-70b-versatile), Spark transforms raw ideas into structured missions, urging users to seek depth over superficial completion.

Spark is designed with an immersive "dark" aesthetic, leveraging rich 3D elements, parallax tilts, and dynamic micro-animations to create a high-fidelity, futuristic environment.

---

## Core Features

### 1. Provocative AI Coaching (The "SPARK" Persona)
Spark isn't just a passive tool; it’s an active counterpart. The `AIService` injects a sharp, intellectual edge into the app. 
- **Mission Structuring:** Transforms a raw input string into a structured 3-part blueprint: a cohesive Title, an Insight ("Spark"), and a Mission Strategy.
- **Socratic Evaluation:** Scores users' steps (0.0 to 1.0) and generates brutal, honest feedback, provocative challenges, and guiding questions if a user's answer is shallow.
- **Workshop Validation:** Analyzes user responses within specific domains to grant Mastery Badges, falling back to local heuristic keyword matching if offline.
- **Tactical Feed:** A live scroll of quotes mimicking system transmissions to provoke thought continuously.

### 2. Challenge-Based Learning (CBL) Pipeline
The architecture revolves around the journey from an initial concept to a validated target.
- **Projects & Steps:** Users organize their work in instances of `CBLProject`, navigating through distinct phase gates (Engage, Investigate, Act).
- **Evolution:** Snapshots of progress (`EvolutionSnapshot`) allow users to track the maturation of their ideas.

### 3. Gamification and Skills Mastery
Spark tracks user progress deeply to encourage consistent activity without cheapening the experience.
- **Daily Streaks and XP:** `UserStats` captures daily progression, granting XP for interactions logged over the timeline.
- **Nexus Mastery Diploma:** A visual badge and certification dynamically updating as the user completes strategic workshops.

### 4. High-Fidelity UI & Interactions
The user experience is defined by the `Core/DesignSystem`, breaking standard UI conventions:
- **Bento Grid Dashboard:** A responsive layout of glassmorphic cards (`GlassCard`), featuring a dynamically updating `HeroBentoCard`.
- **3D Renderings & Parallax Tilt:** The `Spark3DOrb` and `Spark3DComponents` combined with custom tilt animations bring depth to interactable cards.
- **Mesh Backgrounds:** The `SparkMeshBackground` establishes a fluid, animated gradient environment.
- **Haptics:** An integrated `HapticManager` triggers distinct granular jolts on successes, selections, and progression.

---

## Architecture and Methods

### Tech Stack
- **Framework:** SwiftUI (Targeting Apple Platforms)
- **Database:** SwiftData (Managing internal caches and user persistence)
- **Networking:** Async/Await integration directly with the Groq API end-points to achieve ultra-low latency LLM inference.

### Key Modular Directories
- **`App/`**: Contains the root lifecycle `SparkApp.swift`, initializing the `SharedModelContainer` with persistent schemas.
- **`Core/`**: 
  - `Models/`: Contains the entity schema (`CBLProject`, `UserStats`, `Workshop`).
  - `Services/`: Contains singletons like `AIService` controlling API payloads and fallbacks.
  - `DesignSystem/`: Defines `SparkTheme` (Colors, Typography), modifiers, and custom 3D implementations.
- **`Features/`**: Grouped by domain (Dashboard, Onboarding, Gamification, Coach, Timeline). 

### AI Service Methods
- `fetchGroqCompletion(prompt:systemPrompt:)`: Core private HTTP driver generating Llama 3 inferences.
- `structureMission(rawInput:) async -> tuple`: Extracts actionable data via structured prompts.
- `validateWorkshopResponse(...)`: Computes strategic validity against expected benchmarks or offloads to offline heuristics.

---

## Accessibility and Inclusion

While the application is highly stylized to resemble a dark, tactical dashboard, it inherits significant accessibility traits implicitly natively through Apple's ecosystem:
- **Dynamic Typography:** Core fonts integrate SwiftUI's `.system` font rendering, remaining responsive to Apple's Dynamic Type settings inside `SparkTheme.Typography`, thereby scaling fluidly for visually impaired audiences.
- **Contrast & Legibility:** Spark's dark mode palette relies on 'electric' accents (e.g., bright purple, bright green) against a stark black background to maintain high visual contrast bounds.
- **Tactile Reinforcement:** Advanced usage of `HapticManager` functions as an invisible accessibility layer, offering mechanical, physical feedback bridging the gap for visually limited use cases.
- **Offline Fallbacks:** The AI service gracefully falls back to local regex/heuristics on failure or network absence, ensuring functionality regardless of online connectivity.
- **Explicit Labels:** All AI-generated content is clearly identifiable by its distinctive "SPARK" persona and tactical visual language.

---

## AI Ethics & Data Policy

Spark prioritizes user agency and data transparency through a **Consent-First** architecture.

### 1. The Neural Link (Consent Flow)
No user data is transmitted to third-party AI providers (Groq/Llama-3) until the user explicitly accepts the AI Consent agreement. This is managed via the `AIConsentManager`, which persistent stores the user's opt-in status.

### 2. Intelligent Interception
- **Strategic Gates:** All AI-powered features (Idea Spark, Nexus Coach, Evaluation) are programmatically intercepted. Attempting to access them without consent triggers the `AIConsentView`.
- **Anonymized Context:** Data sent for processing is focused strictly on the mission content. Personal identifiers are omitted from coaching prompts to maintain privacy.

### 3. Local Heuristic Resilience
To protect the user's ability to work offline or without AI assistance, Spark includes local validation algorithms. These "Deep-Link" heuristics ensure that progress is not halted by lack of connectivity or refusal of AI consent.

