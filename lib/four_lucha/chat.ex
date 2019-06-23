defmodule FourLucha.Chat do
  @moduledoc false
  @items "chats"
  use FourLucha.BaseHelpers
  use FourLucha.BasePlural

  alias FourLucha.Resource.Chat, as: Chat
  require FourLucha.Client

  defp get_resource do
    Chat
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
