defmodule FourLucha.ObjectTest do
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

  test "responses with a object and Response struct" do
    use_cassette "gb_get_object" do
      response = FourLucha.Object.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Object
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of objects when given query parameters as a map" do
    use_cassette "gb_get_gravity_objects" do
      {status, gravity, req} = FourLucha.Object.get(%{filter: %{name: 'gravity'}})
      assert status == :ok
      assert is_list(gravity)
      assert length(gravity) == 4
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
