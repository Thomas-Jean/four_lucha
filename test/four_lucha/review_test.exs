defmodule FourLucha.ReviewTest do
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

  test "responses with a Review and Response struct" do
    use_cassette "gb_get_review" do
      response = FourLucha.Review.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Review
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of all reviews with a 1 star rating" do
    use_cassette "gb_get_neg_reviews" do
      {status, reviews, req} = FourLucha.Review.get(%{filter: %{score: 1}})

      assert status == :ok
      assert is_list(reviews)
      assert length(reviews) == 19
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
