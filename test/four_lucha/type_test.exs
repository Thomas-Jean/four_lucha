defmodule FourLucha.TypeTest do
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

  test "responses with a list of all types" do
    use_cassette "gb_get_type" do
      {status, types, req} = FourLucha.Type.get(%{})

      assert status == :ok
      assert is_list(types)
      assert length(types) == 25
      assert req.error == "OK"
      assert req.status_code == 1
    end
  end
end
