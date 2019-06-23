defmodule FourLucha.GameRatingTest do
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

  test "responses with a game rating and Response struct" do
    use_cassette "gb_get_game_rating" do
      response = FourLucha.GameRating.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.GameRating
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of game rating when given query parameters as a map" do
    use_cassette "gb_get_esrb_rating" do
      {status, pow, req} = FourLucha.GameRating.get(%{filter: %{name: 'esrb'}})
      assert status == :ok
      assert is_list(pow)
      assert length(pow) == 7
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
