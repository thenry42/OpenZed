---
description: "Record and review past mistakes so we don't repeat them"
---

1. Check if `.opencode/learnings/LEARNINGS.md` exists.

   - If it does, read it and summarize relevant lessons for the current task.
   - If it doesn't, note that no lessons are recorded yet.

2. Ask the user: "Any new lesson to record?"

3. If yes, ensure `.opencode/learnings/LEARNINGS.md` exists (create with a `# Learnings` header if missing), then append a new entry:

   ```markdown
   ## YYYY-MM-DD

   - **tags**: `[tag]` `[tag]`
   - **problem**: what went wrong
   - **fix**: what resolved it
   - **prevention**: how to avoid next time
   ```

   Use simple one-word tags in backticks — e.g. `[config]`, `[python]`, `[shell]`, `[git]`, `[zed]`, `[installer]`. Pick whatever fits the entry.