# Account Switching Guide

## Manual Account Switching Method

When one Amazon Q account runs out of quota, use this simple renaming technique to switch accounts:

### Steps:

1. **Stop the service**
   ```bash
   # Kill process on port 18100
   netstat -ano | findstr :18100
   taskkill /F /PID <PID>
   ```
   Or simply run: `restart_service.bat`

2. **Rename current .env file**
   ```bash
   ren .env .env.account_name_used
   ```
   Example: `ren .env .env.hcxsmyl` or `ren .env .env.245.used`

3. **Copy backup account to .env**
   ```bash
   copy .env.245 .env
   # or
   copy .env.2nd .env
   ```

4. **Update port if needed**
   Edit `.env` and ensure `PORT=18100`

5. **Restart service**
   ```bash
   python main.py
   # or
   restart_service.bat
   ```

### Available Accounts:

- `.env.245` - Account 245
- `.env.2nd` - Account 2nd  
- `.env.hcxsmyl` - Account hcxsmyl (currently exhausted)

### Quick Restart Script:

Use `restart_service.bat` to quickly restart the service without manual process killing.

### Notes:

- All accounts use port 18100 by default
- The service reads credentials from `.env` file only
- Keep backup .env files for easy switching
- Rename used accounts with `.used` suffix to track quota status
