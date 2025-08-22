# ZeroX Solutions Helm Charts

[![Release](https://img.shields.io/github/v/release/zeroxsolutions/charts?label=Release&sort=semver)](https://github.com/zeroxsolutions/charts/releases)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Helm Charts](https://img.shields.io/badge/Helm%20Charts-Multiple-blue.svg)](https://helm.sh/)

A collection of Helm charts for Kubernetes, maintained by ZeroX Solutions. This repository contains various charts for different applications and services.

## Available Charts

This repository contains the following Helm charts:

### cf-tunnel
A Helm chart for deploying Cloudflare Tunnel (cloudflared) to Kubernetes clusters. Cloudflare Tunnel creates a secure, outbound-only connection from your origin server to Cloudflare's edge network. Unlike traditional VPNs or firewall rules, Cloudflare Tunnel doesn't require you to open any inbound ports on your origin server.

### common
Common library Helm charts that provide shared functionality and templates for other charts.

## Features

- 🚀 **Easy Deployment**: Simple Helm chart deployment for various applications
- 🔒 **Secure**: Production-ready security contexts and RBAC configurations
- 📊 **Monitoring Ready**: Built-in health checks and metrics
- 🔧 **Highly Configurable**: Extensive configuration options for different use cases
- 📈 **Scalable**: Support for horizontal pod autoscaling
- 🏗️ **Production Ready**: Includes resource limits, security policies, and best practices
- 📚 **Library Support**: Common templates and functions for consistency

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Internet access to pull container images

## Quick Start

### Add the Repository

All charts are published to a Helm repository hosted on GitHub Pages:

```bash
# Add the repository
helm repo add zeroxsolutions https://zeroxsolutions.github.io/charts
helm repo update

# Search available charts
helm search repo zeroxsolutions
```

### Install Charts

```bash
# Install cf-tunnel
helm install my-tunnel zeroxsolutions/cf-tunnel

# Install other charts as needed
# helm install my-app zeroxsolutions/other-chart
```

### Upgrade Charts

```bash
helm upgrade my-tunnel zeroxsolutions/cf-tunnel
```

### Uninstall Charts

```bash
helm uninstall my-tunnel
```

## Chart Details

### cf-tunnel

A Helm chart for deploying Cloudflare Tunnel (cloudflared) to Kubernetes clusters. Provides secure, outbound-only connections to Cloudflare's edge network.

**Key Features:**
- Secure tunnel connections without opening inbound ports
- Configurable resource limits and autoscaling
- Built-in health checks and monitoring
- Production-ready security contexts

**Documentation:** See [cf-tunnel README](stable/cf-tunnel/README.md) for detailed configuration and usage examples.

### common

A library chart providing shared templates, functions, and common functionality for other charts in the repository.

**Key Features:**
- Reusable Helm templates and helper functions
- Consistent labeling and naming conventions
- Standardized security policies and RBAC
- Common monitoring and health check configurations

**Documentation:** See [common README](stable/common/README.md) for template details and usage.

## Getting Started

### For Users

1. **Add the repository** (see Quick Start above)
2. **Choose a chart** from the available options
3. **Read the chart's README** for specific configuration details
4. **Install and configure** according to your needs

### For Developers

1. **Fork the repository** to contribute
2. **Follow the chart structure** established by existing charts
3. **Use the common library** for shared functionality
4. **Test your changes** thoroughly before submitting

## Chart Structure

```
stable/
├── cf-tunnel/          # Cloudflare Tunnel chart
│   ├── README.md       # Detailed documentation
│   ├── Chart.yaml      # Chart metadata
│   ├── values.yaml     # Default configuration
│   └── templates/      # Kubernetes manifests
├── common/             # Library chart
│   ├── README.md       # Template documentation
│   ├── Chart.yaml      # Library metadata
│   └── templates/      # Shared templates
└── [future-charts]/    # Additional charts
```

## Troubleshooting

### General Issues

1. **Repository not found**: Ensure the repository URL is correct and accessible
2. **Chart not found**: Run `helm repo update` to refresh the repository
3. **Installation fails**: Check the specific chart's README for requirements and configuration

### Getting Help

- **Chart-specific issues**: Check the individual chart's README for troubleshooting
- **Repository issues**: Check [GitHub Issues](https://github.com/zeroxsolutions/charts/issues)
- **General Helm issues**: Refer to [Helm documentation](https://helm.sh/docs/)

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

**Note**: This chart is maintained by [ZeroX Solutions](https://zeroxsolutions.com). 

## Repository Information

- **Helm Repository**: `https://zeroxsolutions.github.io/charts`
- **Available Charts**: `cf-tunnel`, `common`
- **Repository Type**: Multi-chart Helm repository
- **Hosting**: GitHub Pages

For enterprise support and custom configurations, please contact us.
