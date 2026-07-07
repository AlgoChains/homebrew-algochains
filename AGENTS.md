# AGENTS.md

This is the **Homebrew tap** for the AlgoChains CLI. It contains a single formula,
`Formula/algochains.rb`, which installs the `algochains` CLI (packaged from
`algochains-mcp-server` on PyPI) into an isolated virtualenv and links the
`algochains`, `algochains-mcp`, and `algochains-mcp-http` entry points.

## Working here

- **Only `Formula/algochains.rb` matters.** Don't add application code — this repo
  is packaging metadata.
- On each upstream release, the formula's `url`, `sha256`, and `version` are bumped
  automatically by the `update-homebrew` CI job (PyPI sdist URL). Prefer that path
  over hand-editing.
- Install command for users: `brew install algochains/algochains/algochains`.
- The CLI reads the subscriber key from `ALGOCHAINS_SUBSCRIBER_KEY`
  (alias `ALGOCHAINS_SUB_KEY`).
- The `algochains` wrapper enforces a trust ladder (T0 read → T3 live) and a kill
  switch at `~/.algochains/KILLSWITCH` — keep that safety behavior intact.

See `README.md` for user-facing install/usage.
