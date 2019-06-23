defmodule FourLucha.BaseSingular do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      require FourLucha.Client

      def get(id) when is_binary(id) or is_integer(id) do
        case Cachex.get(:gb_cache, "#{@item}:#{id}") do
          {:ok, nil} ->
            case FourLucha.Client.get(build_resource_url(@item, id), [], pool: :four_lucha_pool) do
              {:error, httpError} ->
                {:error, httpError}

              {:ok, response} ->
                case format_response(response) do
                  {:ok, item, response} ->
                    Cachex.put(:gb_cache, "#{@item}:#{id}", item)
                    {:ok, item, response}

                  {:error, item, response} ->
                    {:error, item, response}
                end
            end

          {:ok, item} ->
            {:ok, item, nil}

          {:error, error} ->
            {:error, error}
        end
      end

      def get!(id) when is_binary(id) or is_integer(id) do
        case get(id) do
          {:ok, item, info} ->
            item

          {:error, item, info} ->
            throw(info.error)

          {:error, httpError} ->
            throw(httpError)
        end
      end
    end
  end
end
