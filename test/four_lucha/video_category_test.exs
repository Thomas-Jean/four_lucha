defmodule FourLucha.VideoCategoryTest do
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

  test "responses with a VideoCategory and Response struct" do
    use_cassette "gb_get_video_category" do
      response = FourLucha.VideoCategory.get(11)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.VideoCategory
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of videos" do
    use_cassette "gb_get_video_categories" do
      {status, categories, req} = FourLucha.VideoCategory.get(%{})

      assert status == :ok
      assert is_list(categories)
      assert length(categories) == 11
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
