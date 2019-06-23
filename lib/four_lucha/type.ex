defmodule FourLucha.Type do
  @moduledoc false
  @items "types"
  use FourLucha.BaseHelpers
  use FourLucha.BasePlural

  alias FourLucha.Resource.Type, as: Type
  require FourLucha.Client

  defp get_resource do
    Type
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
