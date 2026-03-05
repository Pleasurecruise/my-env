# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Docker-based development environment repository providing a unified multi-language runtime image for use with GitHub Codespaces, Cloud Native Build (CNB) platform, and JetBrains DevContainers.

## Image Architecture

### Base Image (`Dockerfile`)
Built on `ubuntu:latest`, includes:
- **Node.js**: Managed via NVM (default Node 24) with pnpm, yarn, bun, npm
- **AI CLI tools**: claude-code, gemini-cli, codex
- **Python**: pyenv (Python 3.13) + Miniconda with jupyter, numpy, pandas, scikit-learn, etc.
- **Java**: Managed via SDKMAN (Java 21 default, Java 24 available) + Maven 3.9.11
- **Go**: 1.23.5
- **Rust**: stable via rustup
- **Shell**: zsh + oh-my-zsh with zsh-autosuggestions and zsh-syntax-highlighting plugins

Published to: `ghcr.io/pleasurecruise/my-env:latest`

### IDE Image (`.ide/Dockerfile`)
Extends the base image with JetBrains IDEs (GoLand, IntelliJ IDEA, PyCharm, WebStorm) and code-server (VS Code Web). IDEs are installed to `/ide_cnb` for automatic CNB platform detection.

Published to: `docker.cnb.cool/pleasure1234/my-env:latest`

## CI/CD

### GitHub Actions (`.github/workflows/publish.yml`)
- **Triggers**: Changes to `Dockerfile` pushed to `main`, or `v*` tags
- **Platform**: `linux/amd64`
- **Target**: GitHub Container Registry (ghcr.io)
- Uses GHA cache for faster builds

### CNB Pipeline (`.cnb.yml`)
- **`main` branch push**: Builds and pushes `.ide/Dockerfile` to CNB Registry
- **VSCode workspace**: Uses the base image with 32 CPUs

### GitHub → CNB Sync (`.github/workflows/cnb.yml`)
- Syncs code to `cnb.cool/Pleasure1234/my-env.git` on every push
- Add `[skip cnb]` to commit message to skip sync

## Version Updates

- **Node.js**: Update `NODE_VERSION` in `Dockerfile` and the hardcoded `PATH` line (e.g. `v24.0.0`)
- **Java**: Update `JAVA21_VERSION` or `JAVA24_VERSION` env vars
- **Maven**: Update version in download URLs (multiple mirror fallbacks)
- **Go**: Update `GO_VERSION` env var
- **JetBrains IDEs**: Update download URLs in `.ide/Dockerfile`
