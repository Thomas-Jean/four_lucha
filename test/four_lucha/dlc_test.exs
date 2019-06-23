defmodule FourLucha.DLCTest do
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

  test "responses with a DLC and Response struct" do
    use_cassette "gb_get_dlc" do
      response = FourLucha.DLC.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.DLC
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of DLCs when given query parameters as a map" do
    use_cassette "gb_get_dlc_hero" do
      {status, pow, req} = FourLucha.DLC.get(%{filter: %{name: 'hero'}})
      assert status == :ok
      assert is_list(pow)
      assert length(pow) == 56
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
