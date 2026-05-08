# Einstein vs External LLM Architectural Guide

## Comparison

| Dimension | Einstein Discovery | Prediction Builder | Agentforce | External LLMs |
| --- | --- | --- | --- | --- |
| Best fit | Predictive analytics and outcome explanation | Declarative record scoring | CRM action orchestration | Generative reasoning and custom RAG |
| Latency | Low inside Salesforce | Low inside Salesforce | Low to medium | Vendor and network dependent |
| Cost model | Salesforce licensing | Salesforce licensing | Salesforce licensing | Token and infrastructure cost |
| Governance | Native permissions and audit surfaces | Native permissions and audit surfaces | Native action controls | Custom controls required |
| Data residency | Salesforce boundary | Salesforce boundary | Salesforce boundary | Depends on vendor contract |
| Use-case fit | Win likelihood, churn, revenue signals | Case risk, renewal risk | Triage, action planning | Drafting, summarization, broad synthesis |

## Design Guidance

Start with Einstein when the answer is a score, classification, recommendation, or prediction based on Salesforce data. Start with Agentforce when the workflow needs an agent to interpret CRM state and execute approved actions. Introduce external LLMs only when native features cannot satisfy the language, retrieval, or orchestration requirements.

## Governance Checklist

- Define data categories that can be used for model inputs.
- Store model version, score, confidence, and scoring timestamp.
- Create approval thresholds for pricing and renewal actions.
- Capture user overrides with structured reason codes.
- Separate generated narrative from executable policy decisions.
- Review latency and availability requirements for seller-facing surfaces.

## Use-Case Fit

Einstein Discovery is best for analytics teams that need model transparency and dashboarding. Prediction Builder is best for declarative CRM scoring. Agentforce is best for guided action loops. External LLMs are best for drafting, summarization, and retrieval-heavy experiences that exceed native capability.
