defmodule FourLucha.Object do
  @moduledoc false
  @item "object"
  @items "objects"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Object, as: Object
  require FourLucha.Client

  defp get_resource do
    Object
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
