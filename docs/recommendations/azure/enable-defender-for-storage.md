# Enable Defender for Storage

**Severity:** High
**Category:** Azure platform

## Risk

Storage accounts are a common target for malware upload, data exfiltration,
and anomalous access patterns, but without a detection layer these events
are only visible after the fact — if at all.

## Recommendation

Enable Microsoft Defender for Storage on all storage accounts holding
production or customer-adjacent data, so anomalous access, malware uploads,
and unusual data-transfer patterns raise an alert automatically.

## Example

```text
# Synthetic Azure CLI example (fictitious subscription)
az security pricing create \
  --name StorageAccounts \
  --tier Standard \
  --subscription 00000000-0000-0000-0000-000000000000
```

## References

- https://learn.microsoft.com/azure/defender-for-cloud/defender-for-storage-introduction
