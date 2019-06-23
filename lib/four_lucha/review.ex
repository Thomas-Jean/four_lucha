defmodule FourLucha.Review do
  @moduledoc false
  @item "review"
  @items "reviews"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Review, as: Review
  require FourLucha.Client

  defp get_resource do
    Review
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
