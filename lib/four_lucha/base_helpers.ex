defmodule FourLucha.BaseHelpers do
  @moduledoc false
  defmacro __using__(_opts) do
    quote generated: true do
      alias FourLucha.Resource.Response, as: Response

      require FourLucha.Client

      defp build_resource_url(resource, id) when is_binary(id) or is_integer(id) do
        params = build_query_params()
        "#{resource}/#{id}/?#{params}"
      end

      defp build_resource_url(resource, query) when is_list(query) do
        params = build_query_params()
        "#{resource}/?#{params}&#{Enum.join(query, "&")}"
      end

      defp get_response do
        Response
      end

      defp build_query_params do
        "api_key=#{FourLucha.Client.api_key()}&format=#{FourLucha.Client.format()}"
      end

      defp format_sort(field, direction) do
        build_sort = fn field, direction ->
          "sort=" <> field <> ":" <> direction
        end

        cond do
          direction == "desc" -> build_sort.(field, direction)
          true -> build_sort.(field, "asc")
        end
      end

      defp format_single(query_param) when is_tuple(query_param) do
        build_single = fn label, value ->
          Atom.to_string(label) <> "=" <> value
        end

        cond do
          is_integer(elem(query_param, 1)) ->
            build_single.(elem(query_param, 0), Integer.to_string(elem(query_param, 1)))

          is_binary(elem(query_param, 1)) ->
            build_single.(elem(query_param, 0), elem(query_param, 1))
        end
      end

      defp format_multi(query_param) when is_tuple(query_param) do
        Atom.to_string(elem(query_param, 0)) <> "=" <> Enum.join(elem(query_param, 1), ",")
      end

      defp format_filter(query) when is_map(query) do
        build_filter = fn filter ->
          "filter=" <> filter
        end

        query
        |> Map.keys()
        |> Enum.map(fn key ->
          case query[key] do
            %{:start => start_date, :end => end_date} ->
              "#{key}:#{start_date}|#{end_date}"

            %{:start => start_date} ->
              "#{key}:#{start_date}|#{Date.to_iso8601(DateTime.utc_now())}"

            _ ->
              "#{key}:#{query[key]}"
          end
        end)
        |> Enum.sort()
        |> Enum.join(",")
        |> build_filter.()
      end

      defp format_filter(query) when is_list(query) do
        if Keyword.keyword?(query) do
          build_filter = fn filter ->
            "filter=" <> filter
          end

          query
          |> Enum.map(fn keyword ->
            case elem(keyword, 1) do
              %{:start => start_date, :end => end_date} ->
                "#{elem(keyword, 0)}:#{start_date}|#{end_date}"

              %{:start => start_date} ->
                "#{elem(keyword, 0)}:#{start_date}|#{Date.to_iso8601(DateTime.utc_now())}"

              _ ->
                "#{elem(keyword, 0)}:#{elem(keyword, 1)}"
            end
          end)
          |> Enum.sort()
          |> Enum.join(",")
          |> build_filter.()
        end
      end

      defp format_response(response) do
        {_, data} =
          response
          |> Map.get(:body)
          |> Map.get(:results)
          |> map_to_resource(get_resource())

        {_, info} =
          response
          |> Map.get(:body)
          |> map_to_resource(get_response())

        status = check_error(info)

        {status, data, info}
      end

      defp check_error(response) do
        if response.error == "OK" do
          status = :ok
          status
        else
          status = :error
          status
        end
      end

      defp map_to_resource(response, resource) when length(response) > 0 do
        request_type =
          Enum.map(response, fn x ->
            case resource == Map do
              true -> x
              false -> struct(resource, x)
            end
          end)

        {:ok, request_type}
      end

      defp map_to_resource(response, resource) when length(response) == 0 do
        case resource == Map do
          true -> {:error, resource}
          false -> {:error, struct(resource)}
        end
      end

      defp map_to_resource(response, resource) do
        case resource == Map do
          true -> {:ok, response}
          false -> {:ok, struct(resource, response)}
        end
      end

      defp remove_unneeded_keys(query) do
        key_list = get_known_query_params()

        new_map = for key <- key_list, into: %{}, do: {key, query[key]}
        Enum.filter(new_map, fn {key, value} -> value != nil end)
      end
    end
  end
end
