defmodule FourLucha.Company do
  @moduledoc false
  @item "company"
  @items "companies"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Company, as: Company
  require FourLucha.Client

  defp get_resource do
    Company
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
