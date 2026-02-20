# Render keep-alive (prevent free-tier sleep)

This project includes a Render cron job to keep free-tier web services from idling/sleeping by periodically pinging the app's `/health` endpoint.

Why
- Render free web services may stop serving after ~15 minutes of inactivity. Periodic requests prevent the service from going to sleep and avoid cold-start latency.

What was added
- A `cron` entry was added to `render.yaml` named `keep-awake` which runs every 14 minutes and curls the `/health` endpoint.

How to configure
1. Open `render.yaml` and locate the `cron` block.
2. Replace `https://YOUR_PUBLIC_URL/health` with your deployed service's public URL (for example: `https://picoclaw-openrouter.onrender.com/health`).

Example cron entry (already present in `render.yaml`):

```yaml
cron:
  - name: keep-awake
    schedule: "*/14 * * * *"
    env: docker
    dockerfilePath: Dockerfile.render
    startCommand: >
      sh -lc "curl -fsS --max-time 10 https://YOUR_PUBLIC_URL/health || true"
```

Notes
- The cron job runs in a separate container and must call the public URL of the web service.
- You can alternatively use external monitors (UptimeRobot, GitHub Actions, another host's cron) to achieve the same effect.

Next steps
- Deploy the updated `render.yaml` to Render and verify the cron job runs and the service stays awake (check Render cron logs and the service's first-request latency).
