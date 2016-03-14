# Changlelog

* Moved top level api client from `CogApi` to `CogApi.HTTPClient`.

* Created a `CogApi.Fake.Client` for use in test environments.

* The struct for `:proto, :host, :port, :version, :token, :username, :password`
  as renamed to `CogApi.Endpoint`.

* `role_index` now returns `{:ok, [%CogApi.Resources.Role{}]}` on success.
* `role_create` now returns `{:ok, %CogApi.Resources.Role{}}` on success.

* CogApi.HTTP.Client.authenticate/1 no longer nests the "error" message. It now
  returns tuple of `{:error, "Error message here"}` instead of `{:error,
  %{"error" => "Error message here"}`.

* CogApi.HTTP.Client.authenticate/1 will now return a specific error message if
  the username/password is incorrect. Previously, it returned `{:error, "An
  instance of cog must be running"}`. Now it returns `{:error, "Invalid
  username/password"}`.

* `CogApi.HTTPClient` was renamed to `CogApi.HTTP.Client`.

* params passed to `role_create` must have atoms as keys.

* `CogApi.Client` was introduced as an behavior for `CogApi.HTTP.Client` and
  `CogApi.Fake.Client` to conform to.

* Moved old functionality to `CogApi.HTTP.Old`. Code will stay there until it is
  tested and has a Fake implementation.
