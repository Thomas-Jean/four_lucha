defmodule FourLucha.GameTest do
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

  test "responses with a Game and Response struct" do
    use_cassette "gb_get_game" do
      response = FourLucha.Game.get(1)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Game
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "gets the game with the id that matches our request" do
    use_cassette "gb_get_game" do
      {status, game, req} = FourLucha.Game.get(1)
      assert status == :ok
      assert game.__struct__ == FourLucha.Resource.Game
      assert game.id == 1
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "responses with an error if the game does not exist" do
    use_cassette "gb_get_invalid_game" do
      {status, game, req} = FourLucha.Game.get(10_000_000)
      assert status == :error
      assert game.guid == nil
      assert req.error == "Object Not Found"
      assert req.status_code == 101
    end
  end

  test "responses with a list of Games when given query parameters as a map" do
    use_cassette "gb_get_zelda_games" do
      {status, games, req} = FourLucha.Game.get(%{filter: %{name: 'zelda'}})
      assert status == :ok
      assert is_list(games)
      assert length(games) == 34
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "responses with a list of Games when given query parameters as a keyword list" do
    use_cassette "gb_get_super_mario_games" do
      {status, games, req} = FourLucha.Game.get(%{filter: [name: 'super', name: 'mario']})
      assert status == :ok
      assert is_list(games)
      assert length(games) == 59
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "get games sorted in ascending order" do
    use_cassette "gb_get_kingdom_hearts_sorted_asc" do
      {status, games, req} =
        FourLucha.Game.get(%{
          filter: [name: "Kingdom Hearts"],
          sort: [field: "date_last_updated", direction: "asc"]
        })

      dates = Enum.map(games, & &1.date_last_updated)

      sorted_dates = Enum.sort(dates, &(&1 < &2))

      same_order =
        Enum.zip(dates, sorted_dates)
        |> Enum.map(fn x -> elem(x, 0) == elem(x, 1) end)
        |> Enum.reduce(true, fn x, acc ->
          if acc == false do
            false
          else
            acc == x
          end
        end)

      assert same_order == true
      assert status == :ok
      assert is_list(games)
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "get games with sorted in descending order" do
    use_cassette "gb_get_kingdom_hearts_sorted_desc" do
      {status, games, req} =
        FourLucha.Game.get(%{
          filter: [name: "Kingdom Hearts"],
          sort: [field: "date_last_updated", direction: "desc"]
        })

      dates = Enum.map(games, & &1.date_last_updated)

      sorted_dates = Enum.sort(dates, &(&1 > &2))

      same_order =
        Enum.zip(dates, sorted_dates)
        |> Enum.map(fn x -> elem(x, 0) == elem(x, 1) end)
        |> Enum.reduce(true, fn x, acc ->
          if acc == false do
            false
          else
            acc == x
          end
        end)

      assert same_order == true
      assert status == :ok
      assert is_list(games)
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "get games with a limit param" do
    use_cassette "gb_get_50_games" do
      {status, games, req} = FourLucha.Game.get(%{limit: "50"})

      assert status == :ok
      assert length(games) == 50
      assert is_list(games)
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "get games using offset to move past a limit" do
    use_cassette "gb_get_1_game_without_offset" do
      {status, games, req} = FourLucha.Game.get(%{limit: 1})

      assert status == :ok
      assert length(games) == 1
      assert hd(games).name == "Desert Strike: Return to the Gulf"
      assert req.error == "OK"
      assert req.status_code == 1
    end

    use_cassette "gb_get_1_game_with_offset" do
      {status_offset, games_offset, req_offset} = FourLucha.Game.get(%{limit: 1, offset: 1})

      assert status_offset == :ok
      assert length(games_offset) == 1
      assert hd(games_offset).name == "Breakfree"
      assert req_offset.error == "OK"
      assert req_offset.status_code == 1
    end
  end

  test "get games by date range" do
    use_cassette "gb_get_baffle_ball_by_date" do
      {status, games, req} =
        FourLucha.Game.get(%{
          filter: %{original_release_date: %{start: "1900-01-01", end: "1931-12-31"}}
        })

      assert status == :ok
      assert is_list(games)
      assert length(games) == 1
      assert hd(games).name == "Baffle Ball"
      assert req.error == "OK"
      assert req.status_code == 1
    end

    Cachex.clear(:gb_cache)

    use_cassette "gb_get_baffle_ball_by_date" do
      {status, games, req} =
        FourLucha.Game.get(%{
          filter: [original_release_date: %{start: "1900-01-01", end: "1931-12-31"}]
        })

      assert status == :ok
      assert is_list(games)
      assert length(games) == 1
      assert hd(games).name == "Baffle Ball"
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "get games by start to now" do
    use_cassette "gb_get_with_start" do
      {status, games, req} =
        FourLucha.Game.get(%{filter: %{original_release_date: %{start: "2019-08-31"}}})

      assert status == :ok
      assert is_list(games)
      assert req.error == "OK"
      assert req.status_code == 1
    end

    Cachex.clear(:gb_cache)

    use_cassette "gb_get_with_start" do
      {status, games, req} =
        FourLucha.Game.get(%{filter: [original_release_date: %{start: "2019-08-31"}]})

      assert status == :ok
      assert is_list(games)
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "get games from cache on repeat" do
    use_cassette "gb_get_zelda_games" do
      {status, games, req} = FourLucha.Game.get(%{filter: %{name: 'zelda'}})
      assert status == :ok
      assert is_list(games)
      assert length(games) == 34
      assert req.error == "OK"
      assert req.status_code == 1
    end

    use_cassette "gb_get_zelda_games" do
      {status, games, req} = FourLucha.Game.get(%{filter: %{name: 'zelda'}})
      assert status == :ok
      assert is_list(games)
      assert length(games) == 34
      assert req == nil
    end
  end

  test "get game from cache on repeat" do
    use_cassette "gb_get_game" do
      FourLucha.Game.get(1)

      {status, game, req} = FourLucha.Game.get(1)

      assert status == :ok
      assert game.__struct__ == FourLucha.Resource.Game
      assert game.id == 1
      assert req == nil
    end
  end
end
