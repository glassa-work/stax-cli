# stax

**Your codebase's knowledge brain.** `stax` is a local-first CLI that turns a
repository into a living model of itself: it runs your GitHub Actions locally
before you push, watches `main` and validates every commit, keeps a shareable
session page so anyone can watch an agent work, and maintains the product →
feature → flow graph of your system — all from your machine.

> The source code is developed privately; this repository is the **public
> distribution point**: releases, the installer, and the documentation site.
> Public-repo GitHub Actions minutes build everything here for free.

## Install

macOS / Linux, one line:

```sh
curl -fsSL https://raw.githubusercontent.com/glassa-work/stax-cli/main/install.sh | sh
```

Or download a binary directly from
[Releases](https://github.com/glassa-work/stax-cli/releases) and put it on your
`PATH` (`stax-darwin-arm64.tar.gz`, `stax-darwin-amd64.tar.gz`,
`stax-linux-amd64.tar.gz`, `stax-linux-arm64.tar.gz`).

Verify:

```sh
stax --version
```

## What you get

- **`stax ci`** — run the repo's GitHub Actions locally, honestly, before opening a PR.
- **`stax watch`** — a daemon that validates every commit landing on main; multiple
  developers coordinate through a GitHub commit-status ledger so exactly one
  machine validates each commit.
- **`stax session`** — a live local web page of what an agent is doing: task lanes,
  activity feed, a human-only lane, and a chat box answered by the agent itself.
  `stax session install` teaches Claude Code, Cursor, Kimi, Codex, and every
  AGENTS.md-aware agent to report automatically.
- **`stax graph` / `view-brain`** — the product group → product → feature → flow
  model of your codebase, extracted from your commit history.

## Docs

Full documentation lives at **https://glassa-work.github.io/stax-cli/**.

## License

MIT — see [LICENSE](LICENSE).
