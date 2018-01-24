defmodule LoadTest.TestRunner do
  alias LoadTest.Products.PurchaseProtection
  alias LoadTest.Products.GoProteksiDriver
  alias LoadTest.Auth

  def run_purchase_protection(times, concurrent, start_idx \\1) do
    env_data = Application.get_env(:load_test, :purchase_protection)
    base_url = env_data[:base_url]
    headers = Auth.get_token_headers(base_url,
                                     env_data[:email],
                                     env_data[:password])
    test_runner = build_test_runner(&PurchaseProtection.run/3, base_url, headers)
    run_tests(test_runner, times, concurrent, start_idx)
  end

  def run_go_proteksi(times, concurrent, start_idx \\1) do
    env_data = Application.get_env(:load_test, :go_proteksi)
    base_url = env_data[:base_url]
    headers = Auth.get_basic_headers()
    test_runner = build_test_runner(&GoProteksiDriver.run/3, base_url, headers)
    run_tests(test_runner, times, concurrent, start_idx)
  end

  defp build_test_runner(func, base_url, headers), do: &(func.(&1, base_url, headers))

  defp run_tests(test_runner, times, concurrent, start_idx) do
    run = fn idx ->
      {time, res} = :timer.tc(test_runner, [idx])
      cond do
        res.status_code > 201 -> {false, time, res.status_code}
        true -> {true, time}
      end
    end

    Enum.chunk(start_idx..start_idx + times + 1, concurrent)
    |> Enum.map(fn iteration  ->
      IO.puts("Running #{inspect(iteration)}")
      pmap(iteration, run)
    end)
    |> print_results()
  end

  defp print_results(results) do
    IO.puts("\nPreparing results..\n")
    calc_time = fn acc, iteration -> acc.time + (elem(iteration, 1)/1000) end
    results
    |> List.flatten()
    |> Enum.reduce(%{success: 0, failed: 0, time: 0}, fn(iteration, acc) ->
      if elem(iteration, 0) do
        %{success: acc.success + 1, failed: acc.failed, time: calc_time.(acc, iteration)}
      else
        %{success: acc.success, failed: acc.failed + 1, time: calc_time.(acc, iteration)}
      end
    end)
    |> inspect()
    |> IO.puts()
  end

  defp pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await(&1, 25000))
  end
end
