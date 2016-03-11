# Changlelog

* CogApi.HTTP.Client.authenticate/1 no longer nests the "error" message. It now
  returns tuple of `{:error, "Error message here"}` instead of `{:error,
  %{"error" => "Error message here"}`.

* CogApi.HTTP.Client.authenticate/1 will now return a specific error message if
  the username/password is incorrect. Previously, it returned `{:error, "An
  instance of cog must be running"}`. Now it returns `{:error, "Invalid
  username/password"}`.

* `CogApi.HTTPClient` was renamed to `CogApi.HTTP.Client`.
