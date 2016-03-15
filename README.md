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

## Test

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
