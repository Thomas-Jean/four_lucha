defmodule FourLucha.VideoCategory do
  @moduledoc false
  @item "video_category"
  @items "video_categories"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.VideoCategory, as: VideoCategory
  require FourLucha.Client

  defp get_resource do
    VideoCategory
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
