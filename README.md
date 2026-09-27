# PHENO — Complete MVP Foundation v16

**Simple. Safe. Always.**  
**ساده. ایمن. همیشه.**

Creator signature: **شقایق زیاری**

PHENO is a bilingual Persian/English medication companion architecture for iOS and Android. It is designed around the flow:

**Prescription → Understand → Schedule → Best Way to Take → Safety → Cabinet → Refill → Phase 2 Pharmacy**

## What is included in v16

### 1. Product shell & bilingual UX
- Persian-first RTL and English LTR support.
- PHENO visual system: burgundy, cream, ivory, charcoal, sage.
- Main navigation: Home / Medications / Schedule / Cabinet / Profile.
- Founder/Creator signature shown as **شقایق زیاری**.

### 2. Prescription scanner architecture
- Prescription parsing models for medication name, dose, form, quantity, frequency, duration, and meal instruction.
- Confidence levels and explicit human review.
- OCR provider is an adapter; the current development adapter does not pretend to read real handwriting.
- Uncertain fields are never auto-confirmed.

### 3. Medication management
- Medication records with active ingredient, dose, form, quantity, remaining quantity, doses/day, explicit dose times, PRN flag, and start/end dates.
- Add/update inventory.
- Shared repository boundary for UI and storage.

### 4. Smart Schedule
- Deterministic schedule engine.
- Explicit exact-time and every-X-hours constraints.
- No invented dose times.
- Conflicts/ambiguities are surfaced instead of guessed.
- Dose Events persist locally.

### 5. Reminder engine
- Upcoming / Taken / Missed states.
- Duplicate-safe Dose Event IDs.
- Reminder scheduler abstraction for native iOS/Android notifications.
- No advice to double, stop, substitute, or change treatment after a missed dose.

### 6. Medication Cabinet & Refill
- Remaining inventory.
- Doses/day-based run-out estimation.
- Healthy / Low / Critical / Finished states.
- Refill advice is informational and does not change a prescription.

### 7. Safety & clinical knowledge architecture
- Drug-drug, drug-food/beverage, drug-supplement/herbal, and drug-condition interaction categories.
- Evidence level and source metadata.
- Food & absorption model supports: may improve absorption, take with food, empty stomach, may reduce absorption, timing matters, and no meaningful effect — only when supported by medication-specific evidence.
- Clinical data service is read-only and deliberately separated from OCR/scheduling.

### 8. Security, privacy & sync foundation
- Authentication abstraction.
- Secure Storage abstraction.
- Consent records.
- Audit event model.
- Offline sync queue.
- Conflict states.
- Provider-neutral cloud sync contracts.
- Privacy & Security bilingual screen.

### 9. Pharmacy — Phase 2 boundary
- Pharmacy Finder page is included as a clearly labeled Phase 2 surface.
- It does **not** claim live inventory, reservation, or delivery until official pharmacy integrations are connected.

## Clinical safety principle

> AI helps users understand, organize, and warn; it does not make treatment decisions.

PHENO must not independently change doses, stop medicines, substitute medicines, diagnose conditions, or initiate/alter treatment.

## Production boundary

The current environment does not have Flutter/Dart SDK installed, so an actual `flutter pub get`, iOS build, or Android build has **not** been verified here.

The following remain provider/platform integration tasks before release:

1. Persistent encrypted local database.
2. Platform Keychain/Keystore-backed secure storage.
3. Real authentication provider and session management.
4. Authenticated backend API and encrypted transport.
5. Real sync conflict resolution with an explicit medical-data policy.
6. Native iOS/Android notification implementation and runtime permissions.
7. Camera/photo permissions and a production OCR provider.
8. Licensed/authoritative medication and interaction data with update/version tracking.
9. Production observability, audit retention, deletion/export flows, and privacy/legal review.
10. Pharmacy integrations for Phase 2.

## Development rule

A development adapter must never be presented as production security, production OCR, live pharmacy inventory, or authoritative clinical data.

## Cloud Build

PHENO includes `codemagic.yaml` for cloud builds without a local Flutter installation. The workflow can generate missing native iOS/Android runners, run `flutter analyze`, and produce an iOS IPA or Android APK. iOS TestFlight publishing requires Apple App Store Connect/code-signing credentials configured in Codemagic.

Bundle identifier: `com.pheno.app`

Do not place Apple private keys, passwords, certificates, or API secrets in this repository or chat.
