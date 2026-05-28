# Salesforce DX Agent Instructions

This is a Salesforce DX project.

## Stack

- Apex
- Lightning Web Components (LWC)
- Salesforce CLI
- Playwright
- GitHub

## Deployment

Deploy metadata using:

```bash
sf project deploy start
```

## Testing

Run Apex tests:

```bash
sf apex run test
```

Run Playwright tests:

```bash
npx playwright test
```

## Project Structure

- Apex classes:
  force-app/main/default/classes

- LWCs:
  force-app/main/default/lwc

- Playwright tests:
  tests/playwright

## Rules

- Always generate Apex test classes
- Always deploy after changes
- Run tests after deployment
- Fix deployment errors automatically
- Fix failing Playwright tests automatically
- Commit successful builds to GitHub
- Use best practices for CRUD/FLS/security
- Prefer Flow over Apex when possible
