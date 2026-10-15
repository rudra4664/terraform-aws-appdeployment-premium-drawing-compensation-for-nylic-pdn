# DEV PR review status

Implemented: 1 module labels/directories and output reference; 2, 3, 5 removal of deployment custom IAM policy and its bucket list, following the reviewer identification of CorporateVS as CMF; 7 blank line; 10 t3a.medium selected by user (module support pending); 14 classification changed to Confidential by user direction; 11 gp3 root disks (100 GB retained); 13 CloudAware ignore prefix removed; 16 account-name comment.

Item 4: organization ID retained based on user confirmation that all intended environments use o-m8cxcbau0l. Respond in the PR.
Item 9: user confirmed applied inbound/outbound SG rule quota is 200 and closed this thread. All SG rules retained.

Item 12: replaced unfiltered aws_vpcs/one() lookup with a direct aws_vpc tag:Name filter. The expression nyl-${var.lob}-default-${var.env}-vpc resolves to the user-confirmed nyl-corporatevs-default-dev-vpc for DEV. Existing tier=compute subnet discovery and per-AZ mapping are unchanged. Client plan must verify exactly one matching VPC and that its ID is vpc-01f561f9de6dd3293. No live lookup was performed; other environments' naming is not confirmed by this DEV change.

## Pending client confirmations

- Item 10: t3a.medium is now configured for both DEV instances at user direction. Client must add t3a to the approved family list in the module chain actually used by apps-resources 1.0.9. The supplied rejection occurs in the callable, so changing only an unrelated source module will not resolve it. No deployment module version changed.

- CMF evidence for items 2/3/5: attach Wiz subscription evidence for account 856115015560 tagged appid=APP-13853. Code follows the reviewer's explicit CMF direction; this account tag does not replace application resource appid=APP-511.
- Item 6: app/SRE must confirm whether AmazonRDSFullAccess is required. Retained pending answer.
- Item 8: app/SRE must confirm functional use of PatchGroup and ou. Retained. If adopting nyl:PatchSchedule and nyl:PatchReboot, obtain approved per-node values; no automatic mapping assumed.
- Item 14: datatype removed and nyl:informationClassification=Confidential configured at user direction. Additional EBS volumes receive effective tags through the supplied callable. Root volume is a module gap: callable root_block_device omits tags and instance.volume_tags is not forwarded; source defaults are null/empty. Module owner must forward local.effective_tags into root_block_device.tags (supported by supplied source) or an equivalent volume-tag input. Verify actual root/data volume tags in the client plan. Do not claim complete volume compliance until this is addressed.
- Item 15: platform/SRE must confirm whether nyl:provision is consumed; retained pending answer.

## Verification and scope

DEV only. No SG rule, subnet/AZ, key pair, AMI selector, data volume, snapshot, KMS lookup, module version or provider version changes. New role/profile remains provisioned by the standard Linux callable. Removing the custom policy changes effective access; do not claim Blue permission parity. Standard module internal policies are not removed by this change.

Real registry initialization, TFC plan and reviewer acceptance remain required. If earlier configuration was applied, use STATE-MOVES.md before applying. The older Word export is not updated and must not be used as this revision.

Verification: current formatting passes. Unmodified supplied callable rejects t3a.medium. Conditional offline model with ONLY t3a added to the copied callable allowlist is used to test downstream wiring; it is not a successful validation against the published module. No actual registry/AWS plan performed.
