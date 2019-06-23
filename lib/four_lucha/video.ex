defmodule FourLucha.Video do
  @moduledoc false
  @item "video"
  @items "videos"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Video, as: Video
  require FourLucha.Client

  defp get_resource do
    Video
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
