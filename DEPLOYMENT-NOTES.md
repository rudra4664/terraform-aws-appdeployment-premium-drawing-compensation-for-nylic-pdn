# APP-511 DEV global IAM and regional infrastructure

Root modules.tf calls global and regional-us-east-1. Sibling child modules are under modules/terraform-aws-premium-drawing-compensation-for-nylic-pdn-global and modules/terraform-aws-premium-drawing-compensation-for-nylic-pdn-regional.

Supply env=dev in the client TFC workspace with the existing client-managed dynamic credentials. Defaults contain DEV only. IAM instance profile is passed from global to regional through the root. KMS alias/default is reused.

Read PR-REVIEW-STATUS.md for implemented review changes and outstanding confirmations. This revision is not fully PR-ready until those items are resolved. The older Word export is stale.

Read STATE-MOVES.md if any prior code has been applied. Committing or planning alone does not require state migration.
