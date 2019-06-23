defmodule FourLucha.Client do
  @moduledoc false
  @base_url "https://www.giantbomb.com/api/"
  @format "json"

  use HTTPoison.Base

  def process_request_url(url) do
    @base_url <> URI.encode(url)
  end

  def process_response_body(body) do
    body
    |> Jason.decode!(keys: :atoms)
  end

  def api_key do
    #TODO: move to modern Config and not Mix.Config after a few more
    # elixir versions
    Application.get_env(:four_lucha, :api_key) || System.get_env("GIANT_BOMB_API_KEY")
  end

  def format do
    @format
  end
end
