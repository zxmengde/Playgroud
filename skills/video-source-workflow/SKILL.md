---
name: video-source-workflow
description: Use when Codex needs to summarize or extract evidence from Bilibili, YouTube, course videos, conference videos, webpage videos, subtitles, transcripts, or local audio/video files. Handles metadata, subtitles, timestamps, source limits, and knowledge capture without downloading media, logging in, or using cookies unless the user confirms.
---

# Video Source Workflow

## Trigger

Use for Bilibili, YouTube, courses, conference videos, webpage videos, subtitles, transcripts, local audio or video files, and timestamped summaries.

## Read

Read `docs/workflows/video.md`, `docs/workflows/web.md`, `docs/profile/user-model.md`, and `docs/profile/preference-map.md`.

## Act

Collect verifiable evidence first: URL, title, creator, date, description, part information, subtitles, transcript, and visible page text. Do not claim to have watched or transcribed inaccessible content. Ask before login, cookies, member-only content, full media download, audio extraction, or speech recognition.

## Output

Produce a concise summary with evidence boundaries, optional timestamps, key claims, terms, follow-up questions, and knowledge item when durable.

## Verify

Check subtitle-video correspondence, retrieval method, URL, and sampled timestamps. Formal research claims need paper, official, standard, or institutional support.

