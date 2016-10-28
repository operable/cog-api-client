# CogApi

[![Build status](https://badge.buildkite.com/7990c5595f4defef05b1a07e4d6dce50190b95e488f0346d83.svg?branch=master)](https://buildkite.com/operable/cog-api-client-elixir)

## Installation
1. Add cog_api to your list of dependencies in `mix.exs`:

```elixir
  {:cog_api, github: "operable/cog-api-client"},
```

2. Ensure cog_api is started before your application:

```elixir
  def application do
    [applications: [:cog_api]]
  end
```

## Stucture

There are two main areas of CogApi.

### CogApi.HTTP.Client

This is the primary client that is recommended for usage. This is being tested
as it is updated.

Alongside this, there is a `CogApi.Fake.Client`.
This is designed for testing
and local development purposes.
The API for `Fake.Client`
and `HTTP.Client`
are designed to be identical.
If it functions in `Fake`
it should function the same in `HTTP`.

When adding anything to `HTTP.Client` and `HTTP.Fake`, please:

* Ensure that there are tests for the functionality
* Update the CHANGELOG.md with any changes
* Ensure that `CogApi.Client` is updated with the proper `@callback` so that we
  can ensure that the `Fake` and `HTTP` are in sync.

### CogApi.HTTP.Internal

This client is for use only in `cogctl`.
Do not touch this!
It is also not recommended for external users to use this module.

Eventually `cogctl` will switch to using the `HTTP.Client`
and `Internal` will be removed.

## Tests

Tests and static analysis can be run with:

```
bin/test_suite
```

If tests fail, the script will not perform static analysis.

Run only tests with: `mix test`

ExVcr tests are executed against a local installation of Cog using user "admin"
with the password set to "password". When making a change to the API, you can
record new cassettes by deleting the files you wish to regenerate and run the tests.
Be sure to bootstrap a clean instance of Cog when doing so.

## Static Analysis

Run `mix dialyzer` to run analysis. If your dependencies or your elixir version
change, run `bin/rebuild_plt`.

Note: `dialyzer` requires Elixir v1.2.3 to work properly.
