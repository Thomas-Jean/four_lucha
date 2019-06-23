defmodule FourLucha.VideoTest do
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

  test "responses with a Video and Response struct" do
    use_cassette "gb_get_video" do
      response = FourLucha.Video.get(4)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Video
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of videos" do
    use_cassette "gb_get_murder_island_video" do
      {status, reviews, req} = FourLucha.Video.get(%{filter: %{name: "murder island"}})

      assert status == :ok
      assert is_list(reviews)
      assert length(reviews) == 26
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
