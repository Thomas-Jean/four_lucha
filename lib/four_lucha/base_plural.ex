defmodule FourLucha.BasePlural do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      require FourLucha.Client

      def get(query) when is_map(query) do
        filtered_query = remove_unneeded_keys(query)

        mapper = fn
          {:filter, filters} ->
            format_filter(filters)

          {:sort, sort} ->
            format_sort(sort[:field], sort[:direction])

          {:limit, limit} ->
            format_single({:limit, limit})

          {:offset, offset} ->
            format_single({:offset, offset})

          {:page, page} ->
            format_single({:page, page})

          {:query, query} ->
            format_single({:query, query})

          {:resources, resources} ->
            format_multi({:resources, resources})
        end

        query_param_list = Enum.map(filtered_query, fn x -> mapper.(x) end)
        query_key = Enum.join(query_param_list, ",")

        case Cachex.get(:gb_cache, "#{@items}:#{query_key}") do
          {:ok, nil} ->
            case FourLucha.Client.get(build_resource_url(@items, query_param_list), [],
                   pool: :four_lucha_pool
                 ) do
              {:error, httpError} ->
                {:error, httpError}

              {:ok, response} ->
                case format_response(response) do
                  {:ok, items, response} ->
                    Cachex.put(:gb_cache, "#{@items}:#{query_key}", items)
                    {:ok, items, response}

                  {:error, items, response} ->
                    {:error, items, response}
                end
            end

          {:ok, item} ->
            {:ok, item, nil}

          {:error, error} ->
            {:error, error}
        end
      end

      def get!(query) when is_map(query) do
        case get(query) do
          {:ok, data, info} ->
            data

          {:error, _data, info} ->
            throw(info.error)

          {:error, httpError} ->
            throw(httpError)
        end
      end
    end
  end
end
