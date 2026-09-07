# Enable soft delete on synthetic storage accounts

**Severity:** Medium
**Category:** Azure

## Risk

In the synthetic Contoso training environment, deleted blobs are
unrecoverable, so an accidental delete during an incident cannot be undone.

## Recommendation

Enable blob soft delete with a 7-day retention window on storage accounts in
the training subscription.

## Example

```bash
az storage account blob-service-properties update \
  --account-name stcontosodemo001 \
  --resource-group rg-contoso-demo \
  --enable-delete-retention true \
  --delete-retention-days 7
```
