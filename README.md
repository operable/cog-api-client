# CogApi

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add cog_api to your list of dependencies in `mix.exs`:

        def deps do
          [{:cog_api, "~> 0.0.1"}]
        end

  2. Ensure cog_api is started before your application:

        def application do
          [applications: [:cog_api]]
        end
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

## Static Analysis

Run `mix dialyzer` to run analysis. If your dependencies or your elixir version
change, run `bin/rebuild_plt`.

Note: `dialyzer` requires Elixir v1.2.3 to work properly.
