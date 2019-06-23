defmodule FourLucha.FranchiseTest do
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

  test "responses with a franchise and Response struct" do
    use_cassette "gb_get_franchise" do
      response = FourLucha.Franchise.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Franchise
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of franchise when given query parameters as a map" do
    use_cassette "gb_get_mario_franchise" do
      {status, pow, req} = FourLucha.Franchise.get(%{filter: %{name: 'mario'}})
      assert status == :ok
      assert is_list(pow)
      assert length(pow) == 27
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
