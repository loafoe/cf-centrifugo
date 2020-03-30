# cf-centrifugo
Deploy centrifugo easily to Cloudfoundry

# Environment Variables

| Env | Description | Default  |
|-----|-------------|----------|
| HMAC_SECRET_KEY | Shared secret | |
| API_KEY | The REST API key ||
| ADMIN_PASSWORD | this is a password to log into admin web interface | |
| ADMIN_SECRET | this is a secret key for authentication token set on successful login ||
| PORT | The web port to listen on | 8080 |

# Example manifest

```yaml
---
applications:
- name: centrifugo
  docker:
    image: loafoe/cf-centrifugo:latest
  env:
    HMAC_SECRET_KEY: "z1dGHTHSFGH9"
    API_KEY: "QXDjUqFBmSk1"
    ADMIN_PASSWORD: "Jee5WoE2M5io"
    ADMIN_SECRET: "6aS7Ev5rgBrJ"
  memory: 128M
```

# License

License is MIT