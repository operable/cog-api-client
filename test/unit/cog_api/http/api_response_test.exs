defmodule CogApi.HTTP.ApiResponseTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.ApiResponse
  alias HTTPotion.Response

  describe "format" do
    it "returns the body for a 200" do
      http_response = %Response{status_code: 200, body: Poison.encode!(%{stuff: "things"})}
      expected = {:ok, %{"stuff" => "things"}}
      assert expected == ApiResponse.format(http_response)
    end

    it "returns :ok with a 204" do
      assert :ok = ApiResponse.format(%Response{status_code: 204})
    end

    for code <- 400..500 do
      cond do
        code == 401 ->
          it "returns an authentication error for 401" do
            http_response = %Response{
              status_code: 401,
              body: Poison.encode!(%{error: "User cannot be authenticated"}),
            }

            expected_error = {:authentication_error, ["User cannot be authenticated"]}
            assert expected_error == ApiResponse.format(http_response)
          end
        code == 500 ->
          it "returns an internal server error for 500" do
            http_response = %Response{
              status_code: 500
            }

            expected_error = {:error, ["Internal server error"]}
            assert expected_error == ApiResponse.format(http_response)
          end
        true ->
          it "returns an error for a #{code}" do
            http_response = %Response{status_code: unquote(code), body: Poison.encode!(%{error: "oops"})}
            assert {:error, ["oops"]} == ApiResponse.format(http_response)
          end
      end
    end
  end
end
