---
name: python-flake8
description: Python linting with flake8 — activated when working with .py files
---

Run `flake8` on any Python file before considering it done:

```bash
flake8 <file>
```

If `flake8` isn't installed, suggest: `pip install flake8` or `uv pip install flake8`.

Fix all warnings before moving on. Only suppress a rule with an inline `# noqa:` comment when there's a clear reason.
