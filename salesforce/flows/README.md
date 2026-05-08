# Native AI Flow Patterns

## Einstein Score Threshold Triggers

Use record-triggered Flows to react to score bands rather than raw model outputs. A common pattern is:

1. Score is updated on Opportunity, Account, or Case.
2. Flow compares previous band to current band.
3. Flow creates a task, notification, or approval request only when the band changes.
4. Flow stores an audit note with score, band, model version, and timestamp.

## CPQ Approval Escalation

For CPQ quote approvals:

1. Read recommended discount and confidence from the pricing intelligence surface.
2. Choose approval path from custom metadata thresholds.
3. Require manager approval for medium discounts.
4. Require finance approval for high discounts, low confidence, or strategic exceptions.
5. Capture user override reason before approval submission.

## Churn Alert Notifications

For Service Cloud churn alerts:

1. Trigger when churn risk enters the high band.
2. Set Case priority to High when allowed by policy.
3. Create an account-owner task.
4. Notify customer success and support leadership.
5. Require human review before customer-facing commitments.
