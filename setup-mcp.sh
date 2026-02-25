#!/bin/bash
# Sets up MCP servers for Claude Code (user scope, disabled by default).
# Run once after install. Requires secrets to be set in the environment
# (source ~/.zshrc.local first, or ensure vars are exported).

set -e

check_env() {
    local var="$1"
    if [[ -z "${!var}" ]]; then
        echo "Error: $var is not set. Source ~/.zshrc.local first."
        exit 1
    fi
}

check_env GITLAB_API_TOKEN
check_env JIRA_API_TOKEN
check_env JIRA_EMAIL
check_env CONFLUENCE_API_TOKEN

echo "Setting up MCP servers..."

claude mcp add-json shopify-dev-mcp -s user "$(cat <<EOF
{
  "type": "stdio",
  "command": "npx",
  "disabled": true,
  "args": ["-y", "@shopify/dev-mcp@latest"]
}
EOF
)"
echo "✓ shopify-dev-mcp"

claude mcp add-json gitlab -s user "$(cat <<EOF
{
  "type": "stdio",
  "command": "node",
  "disabled": true,
  "args": ["/Users/benheath/Developer/mcp-gitlab/build/index.js"],
  "env": {
    "GITLAB_API_TOKEN": "$GITLAB_API_TOKEN",
    "GITLAB_API_URL": "https://gitlab.rechargeapps.net/api/v4"
  }
}
EOF
)"
echo "✓ gitlab"

claude mcp add-json mcp-atlassian -s user "$(cat <<EOF
{
  "type": "stdio",
  "command": "uvx",
  "disabled": true,
  "args": ["--python", "3.12", "mcp-atlassian"],
  "env": {
    "JIRA_URL": "https://recharge.atlassian.net",
    "JIRA_USERNAME": "$JIRA_EMAIL",
    "JIRA_API_TOKEN": "$JIRA_API_TOKEN",
    "CONFLUENCE_URL": "https://recharge.atlassian.net/wiki",
    "CONFLUENCE_USERNAME": "$JIRA_EMAIL",
    "CONFLUENCE_API_TOKEN": "$CONFLUENCE_API_TOKEN"
  }
}
EOF
)"
echo "✓ mcp-atlassian"

echo ""
echo "Done. Enable a server with: claude mcp add --scope user <name>"
