defmodule LoadTest do
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      :hackney_pool.child_spec(:first_pool, [timeout: 15000, max_connections: 1000])
    ]

    opts = [strategy: :one_for_one, name: LoadTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

