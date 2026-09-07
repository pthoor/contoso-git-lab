# Require HTTPS-only traffic on storage accounts

**Severity:** High

**Category:** Azure

## Risk

In the synthetic Contoso training environment, storage accounts that accept
plain HTTP allow credentials and blob contents to be read in transit by anyone
positioned on the network path.

## Recommendation

Enable "Secure transfer required" on all storage accounts so the service
rejects any request that is not made over HTTPS.

## Example

```bash
az storage account update \
  --name stcontosodemo002 \
  --resource-group rg-contoso-demo \
  --https-only true
```
