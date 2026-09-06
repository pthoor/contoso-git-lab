# Rotate service principal credentials

**Severity:** Medium
**Category:** Identity

## Risk

Service principal secrets that never expire, or that are rotated manually
and irregularly, tend to live far longer than intended. A long-lived secret
gives an attacker a wide window to use it undetected if it ever leaks into
logs, code, or a misconfigured pipeline.

## Recommendation

Set a maximum credential lifetime for service principals (for example, 90
days), and prefer certificate-based or workload-identity federation over
long-lived client secrets where the workload supports it.

## Example

```text
# Synthetic example (fictitious tenant)
Service principal: demo-deploy-agent
Old client secret:  expires 2099-01-01   # too long-lived
New client secret:  expires in 90 days, rotation reminder scheduled
```

## References

- https://learn.microsoft.com/entra/identity-platform/certificate-credentials
