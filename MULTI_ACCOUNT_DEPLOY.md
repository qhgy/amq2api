# Multi-Account Deployment Guide

This guide explains how to run multiple Amazon Q accounts simultaneously, each on a different port.

## Why Multiple Accounts?

- **Load Balancing**: Distribute requests across multiple accounts
- **Quota Management**: Switch to another account when one reaches monthly limit
- **High Availability**: Automatic failover if one account fails

## Deployment Methods

### Method 1: Docker Compose (Recommended)

Run all accounts simultaneously in separate containers:

```bash
# Start all accounts
docker compose -f docker-compose.multi-account.yml up -d

# Check status
docker compose -f docker-compose.multi-account.yml ps

# View logs
docker compose -f docker-compose.multi-account.yml logs -f

# Stop all
docker compose -f docker-compose.multi-account.yml down
```

**Port Mapping:**
- Account gpzy: http://localhost:18100
- Account 245: http://localhost:18101
- Account 2nd: http://localhost:18102

**Advantages:**
- Each account has isolated token cache
- No cache conflicts
- Easy to scale
- Automatic restart on failure

### Method 2: Manual Switch (Current Setup)

Switch between accounts manually by replacing .env file:

```bash
# Stop service
taskkill /F /IM python.exe

# Clear cache (IMPORTANT!)
del %USERPROFILE%\.amazonq_token_cache*.json

# Switch to account 245
copy .env.245 .env

# Start service
python main.py
```

Or use the restart script:
```bash
restart_service.bat
```

**Advantages:**
- Simple setup
- Single port (18100)
- Lower resource usage

**Disadvantages:**
- Manual switching required
- Service downtime during switch
- Must clear cache to avoid errors

## Cache Management

### Problem: Token Cache Conflicts

When switching accounts, the old token cache can cause authentication errors. This happens because:
1. Service loads cached token from previous account
2. Token belongs to different account
3. API rejects the request with ThrottlingException

### Solution 1: Account-Specific Cache (Implemented)

The code now creates separate cache files for each account:
- `.amazonq_token_cache_8qZacloCz7.json` (Account 245)
- `.amazonq_token_cache_Ws2Sm0zKxV.json` (Account 2nd)
- `.amazonq_token_cache_SS8pQfMa40.json` (Account gpzy)

This prevents cache conflicts when switching accounts.

### Solution 2: Clear Cache on Restart

The `restart_service.bat` script now automatically clears all token caches before starting.

## Account Status Tracking

Current account status:

| Account | Label | Status | Port (Docker) |
|---------|-------|--------|---------------|
| gpzy | gpzyrqs@gmail.com | ✅ Available | 18100 |
| 245 | 245 | ✅ Available | 18101 |
| 2nd | 2nd | ✅ Available | 18102 |
| hcxsmyl | hcxsmyl | ❌ Quota Exhausted | - |

## Load Balancer Setup (Optional)

Use Nginx to distribute requests across multiple accounts:

```nginx
upstream amazonq_backend {
    server localhost:18100;
    server localhost:18101;
    server localhost:18102;
}

server {
    listen 8080;
    
    location / {
        proxy_pass http://amazonq_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_read_timeout 300s;
    }
}
```

## Monitoring

Check health of all accounts:

```bash
# Account gpzy
curl http://localhost:18100/health

# Account 245
curl http://localhost:18101/health

# Account 2nd
curl http://localhost:18102/health
```

## Troubleshooting

### Issue: "ThrottlingException: Maximum reached for this month"

**Cause**: Account quota exhausted

**Solution**: Switch to another account or wait for monthly reset

### Issue: Wrong account being used after switch

**Cause**: Token cache not cleared

**Solution**: 
```bash
del %USERPROFILE%\.amazonq_token_cache*.json
```

### Issue: Port already in use

**Cause**: Previous service still running

**Solution**:
```bash
# Find process
netstat -ano | findstr :18100

# Kill process
taskkill /F /PID <PID>
```

## Best Practices

1. **Use Docker for production**: Isolated environments prevent cache conflicts
2. **Monitor quota usage**: Track requests per account
3. **Implement health checks**: Automatically detect exhausted accounts
4. **Set up alerts**: Get notified when account reaches quota limit
5. **Keep backup accounts**: Always have at least one spare account

## Future Improvements

Potential enhancements:
- Automatic account rotation on quota exhaustion
- Built-in load balancer
- Quota usage dashboard
- Account health monitoring
- Automatic failover
