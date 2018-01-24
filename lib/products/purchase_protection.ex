defmodule LoadTest.Products.PurchaseProtection do
  def run(idx, base_url, headers) do
    :ok = :hackney_pool.start_pool(:pool, [timeout: 15000, max_connections: 10000])
    HTTPoison.post!(build_url(base_url), build_request_body(idx), headers, hackney: [pool: :pool])
  end

  defp build_url(base_url) do
    "#{base_url}/v1.0/purchase-protection/application"
  end

  defp build_request_body(idx) do
    Poison.encode!(%{
      no_ref: "idx-#{idx}",
      customer_name: "test name",
      date_of_birth: "1977-10-02",
      identity_no: "1234567890123456",
      customer_address: "Test Address",
      occupation: "Test Occupation",
      city: "Test City",
      zipcode: "41361",
      phone_no: "8745893458365",
      handphone_no: "-",
      email: "test_email_#{idx}@gmail.com",
      purchase_date: "2017-10-20",
      package_id: "12",
      item: [
        %{
          merk: "GPhone",
          type: "Samsun",
          imei: "b#{idx}",
          harga: "30000000"
        }
      ]
    })
  end
end
