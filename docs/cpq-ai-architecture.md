# CPQ AI Architecture

## Pricing Waterfall with ML Recommendations

1. Start with list price from product catalog.
2. Apply contracted price or account-specific terms.
3. Apply volume and bundle adjustments.
4. Retrieve Einstein discount recommendation and confidence.
5. Apply approval thresholds based on margin, discount depth, and confidence.
6. Persist the recommendation, applied discount, user override reason, and approval result.

## Approval Governance

Recommended discount tiers should not bypass approval policy. Instead, the ML recommendation informs the approval path:

- Low discount and high confidence can follow standard approval.
- Medium discount or medium confidence requires sales manager approval.
- High discount, low confidence, or strategic account exceptions require finance approval.

## Audit Trail Requirements

Capture:

- Quote ID and opportunity ID.
- Recommended discount tier and confidence.
- Applied discount.
- Approval path selected.
- User override reason.
- Model version and scoring timestamp.

## Architecture Principles

Keep pricing policy deterministic and auditable. Use Einstein for recommendation and confidence, CPQ for price calculation, Flow or approval processes for governance, and Agentforce for guided narrative support.
