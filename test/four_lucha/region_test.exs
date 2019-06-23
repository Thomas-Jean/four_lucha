defmodule FourLucha.RegionsTest do
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

  test "responses with a regions and Response struct" do
    use_cassette "gb_get_region" do
      response = FourLucha.Region.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Region
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of all regions" do
    use_cassette "gb_get_all_regions" do
      {status, boards, req} = FourLucha.Region.get(%{})

      assert status == :ok
      assert is_list(boards)
      assert length(boards) == 4
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
