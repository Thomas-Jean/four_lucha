defmodule FourLucha.GameRating do
  @moduledoc false
  @item "game_rating"
  @items "game_ratings"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.GameRating, as: GameRating
  require FourLucha.Client

  defp get_resource do
    GameRating
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
