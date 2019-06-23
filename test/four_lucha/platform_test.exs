defmodule FourLucha.PlatformTest do
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

  test "responses with a Game and Response struct" do
    use_cassette "gb_get_platform" do
      response = FourLucha.Platform.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Platform
      assert elem(response, 1).name == "Amiga"
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of Games when given query parameters as a map" do
    use_cassette "gb_get_commodores" do
      {status, commodores, req} = FourLucha.Platform.get(%{filter: %{name: "commodore"}})

      assert status == :ok
      assert is_list(commodores)
      assert length(commodores) == 5
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
