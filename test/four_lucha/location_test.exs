defmodule FourLucha.LocationTest do
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

  test "responses with a location and Response struct" do
    use_cassette "gb_get_location" do
      response = FourLucha.Location.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Location
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of locations when given query parameters as a map" do
    use_cassette "gb_get_moon_location" do
      {status, moon, req} = FourLucha.Location.get(%{filter: %{name: 'moon'}})
      assert status == :ok
      assert is_list(moon)
      assert length(moon) == 17
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
