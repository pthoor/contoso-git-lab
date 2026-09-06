# Enable MFA for admin accounts

**Severity:** High
**Category:** Identity

## Risk

Administrative accounts without multi-factor authentication are a common
initial-access target. A single leaked or guessed password is enough to
compromise privileged access to the whole environment.

## Recommendation

Require multi-factor authentication for every account holding an
administrative directory role, enforced through Conditional Access rather
than per-user MFA settings, so it cannot be silently disabled per account.

## Example

```text
# Synthetic Conditional Access policy (fictitious tenant)
Policy name:        Require MFA for admin roles
Tenant:             demo.onmicrosoft.com
Assignment:         Directory roles = Global Administrator, Security Administrator
Grant control:      Require multi-factor authentication
State:              On
```

## References

- https://learn.microsoft.com/entra/identity/conditional-access/concept-conditional-access-policies
