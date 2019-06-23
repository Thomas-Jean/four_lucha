defmodule FourLucha.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    FourLucha.Supervisor.start_link(name: FourLucha.Supervisor)
  end
end
