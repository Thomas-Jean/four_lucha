defmodule FourLucha.VideoShowTest do
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

  test "responses with a VideoShow and Response struct" do
    use_cassette "gb_get_video_show" do
      response = FourLucha.VideoShow.get(2)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.VideoShow
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of videos" do
    use_cassette "gb_get_active_premium_shows" do
      {status, shows, req} = FourLucha.VideoShow.get(%{filter: %{active: true, premium: true}})

      assert status == :ok
      assert is_list(shows)
      assert length(shows) == 18
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
