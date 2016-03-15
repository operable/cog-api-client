# Changlelog

* `role_update` now takes an `id` as the second argument. Use
  `CogApi.HTTP.Old.role_update` to update roles by name.

* `role_update` now returns `{:ok, %CogApi.Resources.Role{}}` on success.

* Moved old functionality to `CogApi.HTTP.Old`. Code will stay there until it is
  tested and has a Fake implementation.

* `CogApi.Client` was introduced as an behavior for `CogApi.HTTP.Client` and
  `CogApi.Fake.Client` to conform to.

* params passed to `role_create` must have atoms as keys.

* `CogApi.HTTPClient` was renamed to `CogApi.HTTP.Client`.

* CogApi.HTTP.Client.authenticate/1 will now return a specific error message if
  the username/password is incorrect. Previously, it returned `{:error, "An
  instance of cog must be running"}`. Now it returns `{:error, "Invalid
  username/password"}`.

* CogApi.HTTP.Client.authenticate/1 no longer nests the "error" message. It now
  returns tuple of `{:error, "Error message here"}` instead of `{:error,
  %{"error" => "Error message here"}`.

* `role_create` now returns `{:ok, %CogApi.Resources.Role{}}` on success.

* `role_index` now returns `{:ok, [%CogApi.Resources.Role{}]}` on success.

* The struct for `:proto, :host, :port, :version, :token, :username, :password`
  as renamed to `CogApi.Endpoint`.

* Created a `CogApi.Fake.Client` for use in test environments.

* Moved top level api client from `CogApi` to `CogApi.HTTPClient`.
