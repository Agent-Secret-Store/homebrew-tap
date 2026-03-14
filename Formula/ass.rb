# frozen_string_literal: true

# Agent Secret Store CLI — Homebrew Formula
#
# MAINTAINER NOTE: SHA256 values and version are auto-updated by the
# release-cli GitHub Actions workflow (.github/workflows/release-cli.yml).
# Do not edit the url/sha256 fields manually.
#
# To cut a release that updates this formula:
#   git tag v1.2.3 && git push --tags
#
# To install from the tap:
#   brew tap agent-secret-store/tap
#   brew install ass

class Ass < Formula
  desc "CLI for Agent Secret Store — the secure vault built for AI agents"
  homepage "https://agentsecretstore.com"
  version "1.0.0"
  license "MIT"

  # ──────────────────────────────────────────────────────────────────────────
  # macOS
  # ──────────────────────────────────────────────────────────────────────────
  on_macos do
    on_arm do
      url "https://github.com/moltbot-den/agent-secret-store/releases/download/v#{version}/ass-macos-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end

    on_intel do
      url "https://github.com/moltbot-den/agent-secret-store/releases/download/v#{version}/ass-macos-x64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  # ──────────────────────────────────────────────────────────────────────────
  # Linux
  # ──────────────────────────────────────────────────────────────────────────
  on_linux do
    on_arm do
      # Linux arm64 binary is not currently published.
      # Install via npm instead: npm install -g @agentsecretstore/cli
      odie "ass: Linux arm64 is not yet supported. Install with npm:\n  npm install -g @agentsecretstore/cli"
    end

    on_intel do
      url "https://github.com/moltbot-den/agent-secret-store/releases/download/v#{version}/ass-linux-x64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  # ──────────────────────────────────────────────────────────────────────────
  # Install
  # ──────────────────────────────────────────────────────────────────────────
  def install
    # The downloaded file may or may not have the platform suffix; normalise it.
    binary = Dir["ass-*"].first || Dir["ass"].first
    raise "Could not find ass binary in #{Dir.pwd}" if binary.nil?

    bin.install binary => "ass"
  end

  # ──────────────────────────────────────────────────────────────────────────
  # Post-install caveats
  # ──────────────────────────────────────────────────────────────────────────
  def caveats
    <<~EOS
      Get started:

        ass login                    # Authenticate with your API key
        ass secrets list production  # List secrets in the production namespace
        ass secrets get production/OPENAI_API_KEY  # Retrieve a secret

      Full docs: https://agentsecretstore.com/docs/cli
      MCP setup: https://agentsecretstore.com/docs/sdks/mcp
    EOS
  end

  # ──────────────────────────────────────────────────────────────────────────
  # Test
  # ──────────────────────────────────────────────────────────────────────────
  test do
    # Verify the binary runs and reports the expected version
    assert_match version.to_s, shell_output("#{bin}/ass --version")

    # Verify help text loads without requiring auth
    assert_match "secrets", shell_output("#{bin}/ass --help")
    assert_match "agents",  shell_output("#{bin}/ass --help")
    assert_match "approvals", shell_output("#{bin}/ass --help")
  end
end
