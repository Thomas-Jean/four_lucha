defmodule FourLuchaTest do
  use ExUnit.Case, async: true
  doctest FourLucha

  test "gets api key" do
    assert is_nil(FourLucha.api_key())
  end
end
