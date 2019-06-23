defmodule FourLucha.Person do
  @moduledoc false
  @item "person"
  @items "people"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Person, as: Person
  require FourLucha.Client

  defp get_resource do
    Person
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
