defmodule FourLucha.Resource.Response do
  @moduledoc false
  defstruct(
    status_code: nil,
    error: nil,
    number_of_total_results: nil,
    number_of_page_results: nil,
    limit: nil,
    offset: nil
  )
end
