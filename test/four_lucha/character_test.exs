defmodule FourLucha.CharacterTest do
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

  test "responses with a character and Response struct" do
    use_cassette "gb_get_character" do
      response = FourLucha.Character.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Character
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of character when given query parameters as a map" do
    use_cassette "gb_get_zelda_characters" do
      {status, zeldas, req} = FourLucha.Character.get(%{filter: %{name: 'zelda'}})
      assert status == :ok
      assert is_list(zeldas)
      assert length(zeldas) == 4
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
