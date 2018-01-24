defmodule LoadTest.Products.GoProteksiDriver do
  def run(idx, base_url, headers) do
    HTTPoison.post!(build_url(base_url), build_request_body(idx), headers)
  end

  defp build_url(base_url) do
    "#{base_url}/v1/goproteksi/register"
  end

  defp build_request_body(idx) do
    Poison.encode!(%{
                     name: "Test",
                     email: "test_#{idx}@gmail.com",
                     phone: "+628211223#{idx}",
                     driverID: "91#{idx}",
                     personalID: "88071205#{idx}",
                     vehiclePlateNumber: "B #{idx} UDG",
                     vehicleYear: 2013,
                     origin: "app"
                   })
  end
end
