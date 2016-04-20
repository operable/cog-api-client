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
      it "returns an error for a #{code}" do
        http_response = %Response{status_code: unquote(code), body: Poison.encode!(%{error: "oops"})}
        expected = {:error, ["oops"]}
        assert expected == ApiResponse.format(http_response)
      end
    end

  end

end
