# Cloudinary to Stdout (cld-to-stdout)

A specialized Docker container designed to backup Cloudinary assets and stream them to stdout, specifically for use with [K8up.io](https://k8up.io/) PreBackupPods in Kubernetes environments.

## Overview

This tool downloads all assets from a Cloudinary account and packages them into a tar archive that is streamed to stdout. This design makes it perfect for integration with K8up's backup system, which expects backup data to be provided on stdout.

## How It Works

1. The container authenticates with Cloudinary using provided credentials
2. Downloads all assets from your Cloudinary cloud to a temporary directory
3. Creates a tar archive of the downloaded assets
4. Streams the tar archive to stdout for consumption by K8up

All logs and progress information are sent to stderr, ensuring that stdout remains clean for the backup data stream.

## Configuration

The container requires the following environment variables:

| Variable | Description |
|----------|-------------|
| `CLOUDINARY_API_KEY` | Your Cloudinary API key |
| `CLOUDINARY_API_SECRET` | Your Cloudinary API secret |
| `CLOUDINARY_CLOUD_NAME` | Your Cloudinary cloud name |

## Usage with K8up

### Example K8up PreBackupPod Configuration

```yaml
apiVersion: k8up.io/v1
kind: Backup
metadata:
  name: cloudinary-backup
spec:
  schedule: "0 1 * * *"  # Daily at 1 AM
  failedJobsHistoryLimit: 3
  successfulJobsHistoryLimit: 3
  backend:
    s3:
      endpoint: https://s3.example.com
      bucket: my-backup-bucket
      accessKeyIDSecretRef:
        name: s3-credentials
        key: access-key-id
      secretAccessKeySecretRef:
        name: s3-credentials
        key: secret-access-key
  preBackupPod:
    pod:
      spec:
        containers:
        - name: cloudinary-backup
          image: ghcr.io/yourusername/cld-to-stdout:latest
          env:
          - name: CLOUDINARY_API_KEY
            valueFrom:
              secretKeyRef:
                name: cloudinary-credentials
                key: api-key
          - name: CLOUDINARY_API_SECRET
            valueFrom:
              secretKeyRef:
                name: cloudinary-credentials
                key: api-secret
          - name: CLOUDINARY_CLOUD_NAME
            valueFrom:
              secretKeyRef:
                name: cloudinary-credentials
                key: cloud-name
```
