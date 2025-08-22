# Common Library Helm Chart

[![Chart Version](https://img.shields.io/badge/Chart%20Version-0.0.1-blue.svg)](https://github.com/zeroxsolutions/charts)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A library Helm chart that provides shared templates, functions, and common functionality for other charts in the ZeroX Solutions repository.

## What is this Chart?

The `common` chart is a **library chart** that contains reusable Helm templates, helper functions, and common configurations. It's designed to be used as a dependency by other charts to avoid code duplication and maintain consistency across the repository.

## Features

- 🔧 **Shared Templates**: Common deployment, service, and configuration templates
- 📝 **Helper Functions**: Reusable template functions for naming, labeling, and configuration
- 🏷️ **Standard Labels**: Consistent labeling and annotation schemes
- 🖼️ **Image Management**: Standardized image handling and configuration
- 🔐 **Security Contexts**: Common security policies and RBAC templates
- 📊 **Monitoring**: Standard health checks and metrics configuration

## Usage

This chart is not meant to be installed directly. Instead, it's used as a dependency by other charts:

```yaml
# In other charts' Chart.yaml
dependencies:
  - name: common
    version: 0.0.1
    repository: file://../common
```

## Available Templates

### Core Templates

- `_capabilities.tpl` - Kubernetes capabilities detection
- `_images.tpl` - Image configuration helpers
- `_labels.tpl` - Label and annotation helpers
- `_names.tpl` - Naming convention helpers
- `_serviceaccount.tpl` - Service account templates
- `_tplvalues.tpl` - Template value helpers

### Helper Functions

- `common.capabilities` - Check Kubernetes capabilities
- `common.images` - Standardize image configuration
- `common.labels` - Apply consistent labels
- `common.names` - Generate consistent names
- `common.serviceaccount` - Create service accounts

## Configuration

Since this is a library chart, configuration is handled by the parent charts that depend on it. The `values.yaml` file contains default values that can be overridden.

## Dependencies

This chart has no external dependencies.

## Development

When modifying this chart:

1. **Test changes** with dependent charts
2. **Update version** when making breaking changes
3. **Maintain backward compatibility** when possible
4. **Document new functions** and templates

## Support

- **Issues**: [GitHub Issues](https://github.com/zeroxsolutions/charts/issues)
- **Documentation**: [Chart Documentation](https://github.com/zeroxsolutions/charts)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Note**: This chart is maintained by [ZeroX Solutions](https://zeroxsolutions.com). For enterprise support and custom configurations, please contact us. 