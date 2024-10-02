## [Unreleased]

- Save past questions with `q` and retrieve them with the `qs` command.

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
