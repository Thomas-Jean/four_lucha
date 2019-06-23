defmodule FourLucha.UserReviewTest do
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

  test "responses with a User Review and Response struct" do
    use_cassette "gb_get_user_review" do
      response = FourLucha.UserReview.get(5)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.UserReview
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of user reviews" do
    use_cassette "gb_get_10_user_reviews" do
      {status, reviews, req} = FourLucha.UserReview.get(%{limit: 10})

      assert status == :ok
      assert is_list(reviews)
      assert length(reviews) == 10
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
