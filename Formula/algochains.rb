class Algochains < Formula
  desc "AI-native algorithmic trading CLI — 533 MCP tools, no IDE required"
  homepage "https://algochains.ai"
  # Installs from PyPI (public) — the GitHub release asset requires auth (private repo).
  url "https://files.pythonhosted.org/packages/a4/5d/ffb1c9bb1004856bbfa7654c6e123ea2463ffda479a3ed6f74658c467078/algochains_mcp_server-22.7.1.tar.gz"
  sha256 "3fc24ad7226a1570ab7375a6916453f04f616caed35ebdec9257bb9e41da04e3"
  license "MIT"
  version "22.7.1"

  # CI auto-update: on each release the sha256/url/version are updated via the
  # update-homebrew GitHub Actions job. The PyPI URL format is:
  # https://files.pythonhosted.org/packages/<path>/algochains_mcp_server-<ver>.tar.gz

  depends_on "python@3.11"

  def install
    # Create an isolated virtual environment inside libexec
    venv_dir = libexec
    system "python3", "-m", "venv", venv_dir

    # Install the MCP server package and its core dependencies
    system venv_dir/"bin/pip", "install", "--quiet", "--no-deps", buildpath
    system venv_dir/"bin/pip", "install", "--quiet",
           "algochains-mcp-server==#{version}"

    # Link the two console entry points into the Homebrew bin directory
    bin.install_symlink venv_dir/"bin/algochains-mcp"
    if (venv_dir/"bin/algochains-mcp-http").exist?
      bin.install_symlink venv_dir/"bin/algochains-mcp-http"
    end

    # Safety wrapper for the full CLI (trust ladder, kill switch, dry-run)
    (bin/"algochains").write <<~EOS
      #!/usr/bin/env bash
      # AlgoChains CLI — Safety wrapper v#{version}
      # Trust ladder: T0 (read) → T1 (compute) → T2 (paper) → T3 (live)
      set -euo pipefail

      KILLSWITCH="${HOME}/.algochains/KILLSWITCH"
      TRADE_EXEC="place-order cancel-order close-position flatten-position close-all-positions restart-bot"
      CMD="${1:-}"

      is_in() { local t="$1" l="$2"; for i in $l; do [ "$i" = "$t" ] && return 0; done; return 1; }

      if [ -f "$KILLSWITCH" ] && is_in "$CMD" "$TRADE_EXEC"; then
        echo "🛑 KILL SWITCH ACTIVE — T3 operations blocked. Run: algochains killswitch off"
        exit 1
      fi

      exec "#{venv_dir}/bin/algochains-mcp" "$@"
    EOS

    man1.install "man/man1/algochains.1" if (buildpath/"man/man1/algochains.1").exist?
  end

  def caveats
    <<~EOS
      AlgoChains v#{version} installed.

      Quick start:
        algochains-mcp --help
        python scripts/quickstart.py --mode demo   # (from cloned repo)

      Configure your IDE:
        python scripts/quickstart.py --generate-config cursor

      Kill switch (emergency stop all trades):
        touch ~/.algochains/KILLSWITCH      # activate
        rm   ~/.algochains/KILLSWITCH       # deactivate

      Full docs: https://docs.algochains.ai/cli
    EOS
  end

  test do
    # Verify the MCP server CLI entry point is reachable
    assert_predicate bin/"algochains-mcp", :exist?
  end
end
