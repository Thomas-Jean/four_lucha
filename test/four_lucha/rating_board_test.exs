defmodule FourLucha.RatingBoardTest do
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

  test "responses with a rating board and Response struct" do
    use_cassette "gb_get_rating_board" do
      response = FourLucha.RatingBoard.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.RatingBoard
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of all rating boards" do
    use_cassette "gb_get_all_boards" do
      {status, boards, req} = FourLucha.RatingBoard.get(%{})

      assert status == :ok
      assert is_list(boards)
      assert length(boards) == 6
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
