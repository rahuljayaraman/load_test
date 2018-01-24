defmodule LoadTest.Auth do
  def get_token_headers(base_url, email, password) do
    HTTPoison.post!("#{base_url}/v1.0/signin", build_request_body(email, password), ["Content-Type": "application/json"])
    |> get_body()
    |> Poison.decode!()
    |> build_headers()
  end

  def get_basic_headers do
    [
      "Content-Type": "application/json"
    ]
  end

  defp build_request_body(email, password), do: Poison.encode!(%{email: email, password: password})

  defp get_body(res), do: res.body

  defp build_headers(payload) do
    [
      authorization: payload["token"],
      partnerid: payload["partner_id"],
      "Content-Type": "application/json"
    ]
  end
end
