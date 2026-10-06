# Release Note publication gate

Applies to every future public/internal release and note-only correction, including fast releases. The release agent performs the editorial review; this does not require another owner approval.

Before publishing:

1. Read the previous approved release for format and compare the current release scope with its source and qualification evidence.
2. Make Changes a concise list of this version's user-visible improvements/fixes. Each item must describe an actual change and its affected coin/GPU/behavior. Do not promote unchanged capabilities, historical restrictions, packaging work, double-build checks or internal validation logs into product updates.
3. Preserve useful commands, download links and HiveOS fields from the approved format. Update versions and actual facts, including fees and compatibility. Referencing the old format never restores obsolete pool restrictions, fixed wallets or version-specific historical templates.
4. Check every performance claim against evidence for the stated GPU, conditions and comparison. Do not invent percentages, imply a new benchmark, or extend a single-device result to other models.
5. Keep detailed build/qualification records outside the user-facing note. Retain any compatibility information needed to use the release.
6. Record the review in a separate JSON file, bound to the SHA-256 of the final UTF-8 note. Any subsequent edit invalidates that review. A missing/failed review blocks publication.

Review record schema: schema: 1, exact version, channel (public or internal), note_sha256, nonempty reviewed_by, HTTPS reference_release, changes (ordered objects containing the exact Changes bullet text and nonempty evidence references), and checks with all five fields true:

- current_user_visible_changes_only
- previous_release_format_reviewed
- commands_downloads_fees_and_compatibility_checked
- performance_claims_supported
- internal_process_details_kept_in_validation_records

Use one Changes (or 更新内容 / 更新內容) second-level heading with one concise bullet per reviewed item. No fixed product claim or historical version wording is mandatory. The checker binds a completed review to the text; it cannot determine whether a claim is true. The agent must inspect the evidence before setting the checklist fields.

Run scripts/release_note_review.py with --note, --review, --version and --channel. After writing the release, run it again with --live-release-json containing the fresh GitHub/GitLab API response. It must verify the tag and exact body bytes before reporting completion. Save the returned receipt with delivery evidence.

Public publication: scripts/check-public-release-repo.sh checks every current release-notes/vX.Y.Z.md against the adjacent vX.Y.Z.review.json. Run it before creating/publishing a release or updating a note. A direct API/CLI write does not waive this gate.

Private publication: scripts/publish_private_release.py requires --note-review for both create and update-note, checks it before reading credentials, and binds the live text in its delivery receipt. Bespoke/fast publishers must call the same check before writing and after readback; historical one-time scripts are not future publication entry points.

This gate does not require rebuilding unchanged binaries or repeating GPU tests for note-only edits. Published tags, archives, signatures and original qualification records remain immutable.
