defmodule FourLucha.PromoTest do
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

  test "responses with a promo and Response struct" do
    use_cassette "gb_get_promo" do
      response = FourLucha.Promo.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Promo
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses promos appear to be broken lol" do
    use_cassette "gb_get_promos" do
      {status, _, req} = FourLucha.Promo.get(%{})
      assert status == :ok
      assert req.number_of_total_results == "6"
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
