defmodule FourLucha.ThemeTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney, options: [clear_mock: true]

  ExVCR.Config.filter_url_params(true)

  setup_all do
    HTTPoison.start()
  end

  setup do
    {status, _cleared} = Cachex.clear(:gb_cache)
    status
  end

  test "responses with a Theme and Response struct" do
    use_cassette "gb_get_theme" do
      response = FourLucha.Theme.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Theme
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of all war themes" do
    use_cassette "gb_get_war_themes" do
      {status, themes, req} = FourLucha.Theme.get(%{filter: %{name: "war"}})

      assert status == :ok
      assert is_list(themes)
      assert length(themes) == 2
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
