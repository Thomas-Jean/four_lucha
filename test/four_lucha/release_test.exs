defmodule FourLucha.ReleaseTest do
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

  test "responses with a Release and Response struct" do
    use_cassette "gb_get_release" do
      response = FourLucha.Release.get(158_197)
      assert elem(response, 0) == :ok
      assert elem(response, 1).__struct__ == FourLucha.Resource.Release
      assert elem(response, 2).__struct__ == FourLucha.Resource.Response
    end
  end

  test "responses with a list of all release of katamari damacy" do
    use_cassette "gb_get_katamari_releases" do
      {status, release, req} = FourLucha.Release.get(%{filter: %{name: "katamari damacy"}})

      assert status == :ok
      assert is_list(release)
      assert length(release) == 17
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
