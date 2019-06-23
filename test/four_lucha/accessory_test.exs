defmodule FourLucha.AccessoryTest do
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

  test "responses with a Accessory and Response struct" do
    use_cassette "gb_get_accessory" do
      response = FourLucha.Accessory.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Accessory
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of Accessory when given query parameters as a map" do
    use_cassette "gb_get_dualshock_accessory" do
      {status, shocks, req} = FourLucha.Accessory.get(%{filter: %{name: 'dualshock'}})
      assert status == :ok
      assert is_list(shocks)
      assert length(shocks) == 5
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
