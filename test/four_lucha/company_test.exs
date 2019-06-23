defmodule FourLucha.CompanyTest do
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

  test "responses with a Company and Response struct" do
    use_cassette "gb_get_company" do
      response = FourLucha.Company.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Company
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of Companies when given query parameters as a map" do
    use_cassette "gb_get_hal_labs" do
      {status, hal, req} = FourLucha.Company.get(%{filter: %{name: 'hal laboratory'}})
      assert status == :ok
      assert is_list(hal)
      assert length(hal) == 1
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
