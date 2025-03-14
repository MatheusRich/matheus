## [Unreleased]

## [0.7.1]

- Update sound playback commands to run in the background with success status

## [0.7.0]

_Released 2025-03-03_

- Add `quick-commit` command to commit staged changes with a generated message.

## [0.6.0]

_Released 2025-01-07_

- Allow specifying values on `convert-currency` command.

```sh
$ convert-currency 100 usd eur
```

## [0.5.0]

_Released 2024-12-27_

- Add `convert-currency` command.

## [0.4.0]

_Released 2024-10-02_

- Save past questions with `q` and retrieve them with the `qs` command.
- Reuse answers for the same questions.

## [0.3.0]

_Released 2024-08-27_

- Add `alert-me` command.

## [0.2.0]

_Released 2024-08-26_

- Add `q` command to ask an question to an LLM

```sh
$ q "What is the capital of France?"
The capital of France is **Paris**
```

- Automatically generate executables for the commands when the gem builds.

## [0.1.0]

_Released 2024-02-19_

- Initial release. It includes the commands:

### `puts`: evals the given Ruby code and prints the result

```sh
$ puts 1 + 1
2
```

### `date-of-last`: prints the date of the last week day

```sh
$ date-of-last monday
2024-02-12
```
