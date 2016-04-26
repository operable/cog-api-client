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
      if code == 401 do
        it "returns an authentication error for 401" do
          http_response = %Response{
            status_code: 401,
            body: Poison.encode!(%{error: "User cannot be authenticated"}),
          }

          expected_error = {:authentication_error, ["User cannot be authenticated"]}
          assert expected_error == ApiResponse.format(http_response)
        end
      else
        it "returns an error for a #{code}" do
          http_response = %Response{status_code: unquote(code), body: Poison.encode!(%{error: "oops"})}
          assert {:error, ["oops"]} == ApiResponse.format(http_response)
        end
      end
    end
  end
end
