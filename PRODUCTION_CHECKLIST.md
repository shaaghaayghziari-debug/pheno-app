# PHENO Production Checklist

## Clinical data
- [ ] Select authoritative/licensed medication database.
- [ ] Store source, evidence level, version, and update date.
- [ ] Implement drug-drug, drug-food, drug-supplement, and drug-condition checks.
- [ ] Validate food/absorption statements per medication.
- [ ] Establish pharmacist/clinical review workflow.

## OCR
- [ ] Select Persian + English prescription OCR.
- [ ] Add image preprocessing and privacy-safe upload flow.
- [ ] Preserve confidence per field.
- [ ] Require confirmation before medication-plan creation.

## Local data
- [ ] Replace MemoryLocalStore with persistent encrypted storage.
- [ ] Add migrations/versioning.
- [ ] Add backup/restore policy.
- [ ] Add data deletion/export.

## Authentication & cloud
- [ ] Select identity provider.
- [ ] Implement secure session/token storage.
- [ ] Implement backend API.
- [ ] Encrypt transport.
- [ ] Implement authenticated sync.
- [ ] Define deterministic conflict policy.

## Notifications
- [ ] iOS notification adapter.
- [ ] Android notification adapter.
- [ ] Runtime permissions.
- [ ] Timezone/DST handling.
- [ ] Duplicate protection.
- [ ] Rescheduling after device reboot.

## Pharmacy — Phase 2
- [ ] Pharmacy network integration.
- [ ] Live inventory API.
- [ ] Reservation workflow.
- [ ] Delivery/fulfillment integration where legally supported.

## Release
- [ ] Flutter/Dart CI build.
- [ ] iOS signing.
- [ ] Android signing.
- [ ] Automated tests.
- [ ] Security review.
- [ ] Clinical safety review.
- [ ] Privacy/legal review.
- [ ] Store metadata and accessibility review.
