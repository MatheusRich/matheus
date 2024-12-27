# Matheus

A collection of CLI tools I made for my own use.

## Installation

    $ gem install matheus

## Usage

### [`alert-me`](./lib/matheus/alert_me.rb)

```sh
$ alert-me 'sleep 1 && echo "Done!"'
Done!
```

### [`convert-currency`](./lib/matheus/convert_currency.rb)

```sh
$ convert-currency usd eur
1 USD = 0.92 EUR
```

### [`date-of-last`](./lib/matheus/date_of_last.rb)

Prints the date of the last week day.

```sh
$ date-of-last monday
2024-02-12

$ date-of-last sun
2024-02-11
```

### [`q`](./lib/matheus/q.rb)

It expects a OPENAI_API_KEY environment variable to be set. It will try to load
it from a `.env` file at `~/.env`.

```sh
$ q "What is the capital of France?"
The capital of France is **Paris**
```

### [`puts`](./lib/matheus/puts.rb)

It evaluates the given Ruby code and prints the result. Active Support is
available.

```sh
$ puts 10.days.ago
2024-08-17 15:50:11 -0300
```

## Contributing

Probably not accepting contributions at the moment, but feel free to open an issue if you have any ideas or suggestions.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
