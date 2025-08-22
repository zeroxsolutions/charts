# Cloudflare Tunnel Helm Chart

[![Release](https://img.shields.io/github/v/release/zeroxsolutions/charts?label=Release&sort=semver)](https://github.com/zeroxsolutions/charts/releases)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Helm Chart](https://img.shields.io/badge/Helm%20Chart-cf--tunnel-blue.svg)](https://helm.sh/)

A Helm chart for deploying Cloudflare Tunnel (cloudflared) to Kubernetes clusters. This chart provides a simple and configurable way to run Cloudflare Tunnels in your Kubernetes environment.

## What is Cloudflare Tunnel?

Cloudflare Tunnel creates a secure, outbound-only connection from your origin server to Cloudflare's edge network. Unlike traditional VPNs or firewall rules, Cloudflare Tunnel doesn't require you to open any inbound ports on your origin server.

## Features

- 🚀 **Easy Deployment**: Simple Helm chart deployment with customizable values
- 🔒 **Secure**: Runs with appropriate security contexts and RBAC
- 📊 **Monitoring Ready**: Built-in health checks and readiness probes
- 🔧 **Highly Configurable**: Extensive configuration options for various use cases
- 📈 **Scalable**: Support for horizontal pod autoscaling
- 🏗️ **Production Ready**: Includes resource limits, security policies, and best practices

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A Cloudflare account with Tunnel configured

## Quick Start

### Install from GitHub Container Registry (GHCR)

This chart is published to GitHub Container Registry (GHCR). You have two options to install:

#### Option 1: Direct OCI Install (Recommended)
```bash
# Login to GHCR (only needed once)
helm registry login ghcr.io

# Install directly from GHCR
helm install my-tunnel oci://ghcr.io/zeroxsolutions/charts
```

#### Option 2: Add as Helm Repository
```bash
# Add the repository
helm repo add zeroxsolutions https://zeroxsolutions.github.io/charts
helm repo update

# Install from repo
helm install my-tunnel zeroxsolutions/cf-tunnel
```

### Install the Chart

```bash
# Option 1: Direct OCI install
helm install my-tunnel oci://ghcr.io/zeroxsolutions/charts/cf-tunnel

# Option 2: From added repository
helm install my-tunnel zeroxsolutions/cf-tunnel

# Install with custom values (either way works)
helm install my-tunnel oci://ghcr.io/zeroxsolutions/charts/cf-tunnel \
  --set cloudflared.token="your-tunnel-token" \
  --set replicaCount=2
```

### Upgrade the Chart

```bash
helm upgrade my-tunnel oci://ghcr.io/zeroxsolutions/charts/cf-tunnel
```

### Uninstall the Chart

```bash
helm uninstall my-tunnel
```

## Configuration

### Required Configuration

The most important configuration is your Cloudflare Tunnel token:

```yaml
cloudflared:
  token: "your-cloudflare-tunnel-token"
```

### Common Configuration Options

```yaml
# Basic deployment settings
replicaCount: 2
image:
  repository: cloudflare/cloudflared
  tag: "2025.4.2"
  pullPolicy: IfNotPresent

# Resource allocation
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

# Security settings
podSecurityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 1000

# Autoscaling
autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 70
```

### Advanced Configuration

```yaml
# Custom environment variables
extraEnvVars:
  - name: TUNNEL_PROTOCOL
    value: "http2"
  - name: TUNNEL_ORIGIN_CA_POOL
    value: "/etc/ssl/certs/ca-certificates.crt"

# Custom arguments
extraArgs:
  - "--protocol"
  - "http2"
  - "--metrics"
  - "0.0.0.0:9090"

# Node affinity
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/os
          operator: In
          values:
          - linux

# Pod disruption budget
podDisruptionBudget:
  enabled: true
  minAvailable: 1
```

## Values Reference

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `cloudflare/cloudflared` |
| `image.tag` | Container image tag | `2025.4.2` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `resources.requests.cpu` | CPU resource requests | `100m` |
| `resources.requests.memory` | Memory resource requests | `128Mi` |
| `autoscaling.enabled` | Enable horizontal pod autoscaling | `false` |
| `autoscaling.minReplicas` | Minimum replicas for HPA | `1` |
| `autoscaling.maxReplicas` | Maximum replicas for HPA | `3` |
| `cloudflared.token` | Cloudflare Tunnel token | `""` (required) |

For a complete list of configurable values, see the [values.yaml](stable/cf-tunnel/values.yaml) file.

## Usage Examples

### Basic Tunnel Setup

```yaml
# values-basic.yaml
cloudflared:
  token: "your-tunnel-token"

replicaCount: 1
resources:
  requests:
    cpu: 100m
    memory: 128Mi
```

```bash
helm install basic-tunnel oci://ghcr.io/zeroxsolutions/charts/cf-tunnel -f values-basic.yaml
```

### Production Setup with High Availability

```yaml
# values-production.yaml
cloudflared:
  token: "your-tunnel-token"

replicaCount: 3
resources:
  requests:
    cpu: 200m
    memory: 256Mi
  limits:
    cpu: 1000m
    memory: 1Gi

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70

podSecurityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 1000

securityContext:
  capabilities:
    drop:
      - ALL
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```

```bash
helm install prod-tunnel oci://ghcr.io/zeroxsolutions/charts/cf-tunnel -f values-production.yaml
```

### Development Setup

```yaml
# values-dev.yaml
cloudflared:
  token: "your-dev-tunnel-token"

replicaCount: 1
resources:
  requests:
    cpu: 50m
    memory: 64Mi

extraArgs:
  - "--loglevel"
  - "debug"
  - "--metrics"
  - "0.0.0.0:9090"
```

```bash
helm install dev-tunnel oci://ghcr.io/zeroxsolutions/charts/cf-tunnel -f values-dev.yaml
```

## Troubleshooting

### Common Issues

1. **Pod fails to start**: Check if the Cloudflare token is valid and properly configured
2. **High resource usage**: Adjust resource limits and requests in the values
3. **Connection issues**: Verify network policies and firewall rules allow outbound connections

### Debug Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=cf-tunnel

# View pod logs
kubectl logs -l app.kubernetes.io/name=cf-tunnel

# Describe pod for more details
kubectl describe pod -l app.kubernetes.io/name=cf-tunnel

# Check events
kubectl get events --sort-by='.lastTimestamp'
```

### Health Checks

The chart includes built-in health checks:

- **Liveness Probe**: Ensures the container is running
- **Readiness Probe**: Ensures the container is ready to serve traffic

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/zeroxsolutions/charts/issues)
- **Documentation**: [Chart Documentation](https://github.com/zeroxsolutions/charts)
- **Community**: [Discussions](https://github.com/zeroxsolutions/charts/discussions)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.

---

**Note**: This chart is maintained by [ZeroX Solutions](https://zeroxsolutions.com). For enterprise support and custom configurations, please contact us.
