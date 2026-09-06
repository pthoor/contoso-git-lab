# Retry policy — synthetic baseline config

This file exists for the guided merge-conflict exercise in `LAB.md`. It's a
tiny, deliberately simple config so the conflict itself is easy to read.

Do not "fix" the conflict before the exercise — both partners should branch
from this exact file.

## Configuration

```text
service       = security-score-api
retry_count = 9
backoff       = exponential
timeout_ms    = 2000
```

## Notes

`retry_count` controls how many times the synthetic `security-score-api`
service retries a failed call before giving up. During the exercise, both
partners will independently change this same line to different values —
that's what produces the conflict.
