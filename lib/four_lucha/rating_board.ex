defmodule FourLucha.RatingBoard do
  @moduledoc false
  @item "rating_board"
  @items "rating_boards"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.RatingBoard, as: RatingBoard
  require FourLucha.Client

  defp get_resource do
    RatingBoard
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
