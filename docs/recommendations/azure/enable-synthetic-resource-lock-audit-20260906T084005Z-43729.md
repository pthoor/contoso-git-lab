# Audit resource locks on critical synthetic resources

**Severity:** Medium
**Category:** Azure platform

## Risk

Critical resources without an expected management lock can be deleted or
changed accidentally. Missing locks can also indicate that a deployment
drifted from its approved synthetic baseline.

## Recommendation

Inventory critical resources weekly and confirm each one has the expected
`CanNotDelete` lock. Investigate and restore any missing lock through the
approved infrastructure workflow.

## Example

```bash
az lock list \
  --resource-group rg-contoso-training-001 \
  --query "[?level=='CanNotDelete'].{name:name,level:level}"
```

## References

- [Lock Azure resources](https://learn.microsoft.com/azure/azure-resource-manager/management/lock-resources)
