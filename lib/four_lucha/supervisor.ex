defmodule FourLucha.Supervisor do
  @moduledoc false
  use Supervisor
  import Cachex.Spec

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    size =
      Application.get_env(:four_lucha, :cache_limit) || System.get_env("FOUR_LUCHA_CACHE_LIMIT") ||
        500

    children = [
      {Cachex,
       name: :gb_cache, limit: limit(size: size, policy: Cachex.Policy.LRW, reclaim: 0.1)},
      :hackney_pool.child_spec(:four_lucha_pool, timeout: 15000, max_connections: 100)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
