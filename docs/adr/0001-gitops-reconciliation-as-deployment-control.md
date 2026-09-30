# ADR 0001: GitOps Reconciliation as Deployment Control

## Status
Accepted

## Context
Direct changes to Kubernetes make promotion, rollback and drift difficult to review consistently across dev, staging and production.

## Decision
Git-managed desired state is the deployment authority. Jenkins updates approved image versions in this repository and Argo CD reconciles the target environment. Manual cluster changes are treated as temporary incident actions, not normal configuration management.

## Consequences
- Promotion is tied to a reviewable Git change.
- Rollback is performed by restoring a known-good desired state.
- Drift becomes visible through reconciliation status.
- CI/CD and runtime concerns stay separated.
- Argo CD availability and repository controls become part of the delivery dependency chain.
