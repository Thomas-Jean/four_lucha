defmodule FourLucha.Concept do
  @moduledoc false
  @item "concept"
  @items "concepts"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Concept, as: Concept
  require FourLucha.Client

  defp get_resource do
    Concept
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
