# Periodic Tasks (Heartbeat)

This file defines tasks that run automatically every 14 minutes to keep the service active and healthy.

## Quick Status Checks

- Check the current time and health status
- Verify OpenRouter API connectivity

## Notes

- Tasks run automatically on the configured heartbeat interval (14 minutes)
- Use the `message` tool to send updates to the user
- Long-running tasks should use `spawn` to avoid blocking the heartbeat
