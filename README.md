# homebrew-algochains

The official [Homebrew](https://brew.sh) tap for the AlgoChains CLI.

## Install

```bash
brew install algochains/algochains/algochains
```

This taps `algochains/algochains` and installs the **`algochains`** command-line tool
(packaged from [`algochains-mcp-server`](https://pypi.org/project/algochains-mcp-server/),
the AI-native trading CLI with the full MCP tool suite). The formula installs into an
isolated virtualenv and links these entry points:

- `algochains` — the CLI safety wrapper (trust ladder T0→T3, kill switch, dry-run).
- `algochains-mcp` — the MCP server / CLI backend.
- `algochains-mcp-http` — the HTTP transport (when present).

## Configure your subscriber key

The CLI authenticates with your AlgoChains subscriber key. Set it in your shell:

```bash
export ALGOCHAINS_SUBSCRIBER_KEY="sub_live_…"
# ALGOCHAINS_SUB_KEY is accepted as an alias
```

Then verify:

```bash
algochains-mcp --help
```

## Kill switch

Emergency stop for all live (T3) trade operations:

```bash
touch ~/.algochains/KILLSWITCH      # activate — blocks place/cancel/close/flatten
rm   ~/.algochains/KILLSWITCH       # deactivate
```

## Updating

```bash
brew update && brew upgrade algochains
```

Releases update the formula's `url` / `sha256` / `version` automatically via the
`update-homebrew` CI job.

## License

MIT — see [`LICENSE`](LICENSE).
