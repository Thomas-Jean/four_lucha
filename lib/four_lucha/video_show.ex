defmodule FourLucha.VideoShow do
  @moduledoc false
  @item "video_show"
  @items "video_shows"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.VideoShow, as: VideoShow
  require FourLucha.Client

  defp get_resource do
    VideoShow
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
