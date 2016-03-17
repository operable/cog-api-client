# Changelog

* The `role_revoke` function now takes a `%Role{}`, and a `%Group{}` instead of
  names. It returns a `%Group{}` with the associated roles as an attribute. The
  original `role_revoke` can still be used for users.

* The `role_grant` function now takes a `%Role{}`, and a `%Group{}` instead of
  names. It returns a `%Group{}` with the associated roles as an attribute. The
  original `role_grant` can still be used for users.

* The `bundle_status`, `bundle_enable` and `bundle_disable` functions were
  removed. All calls should now go through `bundle_update` and pass the
  `enabled:` as `true` or `false`. This command returns `{:ok, %Bundle}`.

* The `users_index` now returns `{:ok, [%User{}]}` on success
* The `users_create` now returns `{:ok, %User{}}` on success

* The `bundle_index` now returns `{:ok, [%Bundle{}]}` on success

* The `groups_index` now returns a list of `%Group{}` structs instead of a map.

* The `permission_create` now takes a single parameter of `name`. This will be
  used as the name of the command and a default `site` namespace. The fake
  server will accept a `:` separating the namespace and the command name.

* The `permission_index` now returns a `%Permission` struct instead of a bare
  map.

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
