defmodule FourLucha.PersonTest do
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

  test "responses with a person and Response struct" do
    use_cassette "gb_get_person" do
      response = FourLucha.Person.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Person
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of people when given query parameters as a map" do
    use_cassette "gb_get_hideo" do
      {status, hideo, req} = FourLucha.Person.get(%{filter: %{name: 'hideo'}})
      assert status == :ok
      assert is_list(hideo)
      assert length(hideo) == 47
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
