defmodule FourLucha.SearchTest do
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

  test "returns the search results" do
    use_cassette "gb_search_mega_man" do
      {status, search, req} = FourLucha.Search.get(%{query: "mega man"})

      assert status == :ok
      assert is_list(search)
      assert length(search) == 10
      assert is_map(hd(search))
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "returns the search results filtered by resource" do
    use_cassette "gb_search_doom_games" do
      {status, search, req} = FourLucha.Search.get(%{query: "doom", resources: ["game"]})

      assert status == :ok
      assert is_list(search)
      assert length(search) == 10
      assert is_map(hd(search))

      Enum.map(search, fn x ->
        assert Map.get(x, :resource_type) == "game"
      end)

      assert req.error == "OK"
      assert req.status_code == 1
    end
  end

  test "returns deeper search results by page" do
    id_set_1 =
      use_cassette "gb_search_page_1" do
        {_, search, _} = FourLucha.Search.get(%{query: "boom", page: 1})

        guid_set = MapSet.new()

        Enum.map(search, fn x -> MapSet.put(guid_set, Map.get(x, :guid)) end)

        guid_set
      end

    id_set_2 =
      use_cassette "gb_search_page_2" do
        {_, search, _} = FourLucha.Search.get(%{query: "boom", page: 2})

        guid_set = MapSet.new()

        Enum.map(search, fn x -> MapSet.put(guid_set, Map.get(x, :guid)) end)

        guid_set
      end

    assert MapSet.disjoint?(id_set_1, id_set_2)
  end
end
