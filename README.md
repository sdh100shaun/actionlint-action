# actionlint-action

A GitHub Action that lints your GitHub Actions workflow files using [actionlint](https://github.com/rhysd/actionlint) — a static checker for GitHub Actions workflow files.

## Features

- Lints all workflow files in `.github/workflows/` automatically
- Optional [shellcheck](https://www.shellcheck.net/) integration for shell scripts in `run:` steps
- Optional [pyflakes](https://github.com/PyCQA/pyflakes) integration for Python scripts in `run:` steps
- Suppress specific errors using regex ignore patterns
- Target specific files or directories instead of scanning all workflows

## Usage

### Basic — lint all workflows

```yaml
name: Lint workflows

on:
  push:
    paths:
      - '.github/workflows/**'
  pull_request:
    paths:
      - '.github/workflows/**'

jobs:
  actionlint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: your-org/actionlint-action@v1
```

### Lint specific files

```yaml
- uses: your-org/actionlint-action@v1
  with:
    files: .github/workflows/ci.yml .github/workflows/deploy.yml
```

### Suppress specific errors

```yaml
- uses: your-org/actionlint-action@v1
  with:
    ignore: |
      SC2086
      property "foo" is not defined in object type
```

### Disable shellcheck or pyflakes

```yaml
- uses: your-org/actionlint-action@v1
  with:
    shellcheck: "false"
    pyflakes: "false"
```

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `files` | No | `""` | Space-separated list of workflow files or directories to lint. When empty, scans `.github/workflows/` automatically. |
| `ignore` | No | `""` | Newline-separated list of regular expression patterns. Any error whose message matches a pattern will be suppressed. |
| `shellcheck` | No | `"true"` | Enable [shellcheck](https://www.shellcheck.net/) integration for shell scripts in `run:` steps. Set to `"false"` to disable. |
| `pyflakes` | No | `"true"` | Enable [pyflakes](https://github.com/PyCQA/pyflakes) integration for Python scripts in `run:` steps. Set to `"false"` to disable. |

## Outputs

This action produces no outputs. It exits with a non-zero status code if any linting errors are found, causing the workflow job to fail.

## Installation

This action runs as a Docker container — no additional setup or dependencies are required on the runner. It uses:

- **actionlint** [`rhysd/actionlint:1.7.11`](https://github.com/rhysd/actionlint) — the core linter
- **shellcheck** — bundled with the actionlint image, used for shell script analysis
- **pyflakes** — installed via Alpine's package manager, used for Python script analysis

### Pinning to a specific version

It is strongly recommended to pin this action to a specific commit SHA or tag to prevent unexpected changes:

```yaml
- uses: your-org/actionlint-action@v1        # tag
- uses: your-org/actionlint-action@ddfc272   # commit SHA (most secure)
```

## Examples

### Full example with all options

```yaml
name: Lint workflows

on:
  push:
    branches: [main]
    paths:
      - '.github/workflows/**'
  pull_request:
    paths:
      - '.github/workflows/**'

jobs:
  actionlint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Lint GitHub Actions workflows
        uses: your-org/actionlint-action@v1
        with:
          files: .github/workflows/ci.yml
          ignore: |
            SC2086
          shellcheck: "true"
          pyflakes: "false"
```

### Run on every push regardless of changed files

```yaml
jobs:
  actionlint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: your-org/actionlint-action@v1
```

## How it works

1. The action builds and runs a Docker container based on Alpine Linux.
2. `actionlint` is copied from the official `rhysd/actionlint` image.
3. `shellcheck` is also copied from the official image and enabled by default.
4. `pyflakes` is installed from Alpine's package registry and enabled by default.
5. The `entrypoint.sh` script translates action inputs into `actionlint` CLI flags and runs the linter.

## Contributing

Pull requests and issues are welcome. Please open an issue before submitting large changes.

## License

See [LICENSE](LICENSE) for details.
