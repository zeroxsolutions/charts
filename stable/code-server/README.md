# Helm documentation

## Use NGINX Ingress Controller

Enable snippets in NGINX Ingress Controller

```yaml
ingress:
  annotations:
    nginx.org/location-snippets: |
      proxy_set_header Host $host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
```
