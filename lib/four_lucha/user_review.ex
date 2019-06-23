defmodule FourLucha.UserReview do
  @moduledoc false
  @item "user_review"
  @items "user_reviews"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.UserReview, as: UserReview
  require FourLucha.Client

  defp get_resource do
    UserReview
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
