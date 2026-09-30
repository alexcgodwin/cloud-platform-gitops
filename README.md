# Cloud Platform GitOps

A Kubernetes delivery repository that separates application source from runtime desired state. Jenkins promotes approved image versions here; Argo CD reconciles dev, staging and production environments from Git.

## Engineering Intent

This repository is the operating contract between CI and Kubernetes. It keeps environment state reviewable, makes drift visible and gives rollback a versioned source of truth instead of relying on manual cluster changes.

## Delivery Flow

```text
Application commit
      |
      v
Jenkins build / test / image publish
      |
      v
Git image version update
      |
      v
Argo CD reconciliation
      |
      v
Kubernetes environment
      |
      v
Health, metrics, logs and failure validation
```

## Reviewable Evidence

| Concern | Artifact |
| --- | --- |
| Runtime workloads | `applications/base/` |
| Network isolation | `applications/base/networkpolicy.yaml` |
| Autoscaling | `applications/base/hpa.yaml` |
| Disruption control | `applications/base/pdb.yaml` |
| Production reconciliation | `argocd/prod.yaml` |
| Environment separation | `environments/dev`, `environments/staging`, `environments/prod` |
| Metrics | `monitoring/values.yaml` and ServiceMonitor resources |
| Logging | `monitoring/logging/` |
| Dashboard | `monitoring/dashboards/cloud-platform-api-observability.json` |
| Failure testing | `runbooks/failure-tests.md` |
| Architecture decision | `docs/adr/0001-gitops-reconciliation-as-deployment-control.md` |

## Platform Controls

- Non-root workload security contexts and restricted runtime assumptions.
- Readiness and liveness probes before traffic is considered healthy.
- Horizontal Pod Autoscaling for the API workload.
- PodDisruptionBudget controls for planned disruption.
- NetworkPolicy to reduce unnecessary east-west communication.
- Environment-specific Kustomize overlays instead of duplicated manifests.
- Prometheus/Grafana observability and Loki/Alloy logging configuration.

## Decision and Failure Model

Git is the normal deployment authority. Manual runtime changes are treated as incident actions and must be reconciled back into versioned desired state. Failure testing focuses on rollout health, routing, workload readiness, scaling behavior and recovery of application flow.

## Tradeoffs

- GitOps adds a reconciliation dependency but improves auditability and rollback discipline.
- Environment overlays reduce duplication but require clear ownership of shared base configuration.
- HPA improves elasticity but depends on valid resource requests and metrics availability.
- NetworkPolicy improves isolation but can create hard-to-diagnose connectivity failures if ownership and testing are weak.
- Persistent database workloads require stronger backup and storage design than stateless services.

## What This Repository Proves

It proves that the Kubernetes platform was designed and validated as a delivery system, not just as a set of YAML files: source control, promotion, runtime policy, autoscaling, observability, environment separation and failure handling are connected.

## What It Does Not Claim

The previously validated AWS runtime was later decommissioned for cost control. The repository preserves the implementation and evidence; it does not claim that the original EKS environment is permanently running today.
