# FourLucha

**Giant Bomb API Client With Automatic Client-Side Caching**

## Installation

The package can be installed by adding `four_lucha` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    #...
    {:four_lucha, "~> 0.1.0"}
  ]
end
```
and then run `mix deps.get` and  `mix deps.compile`

## Setup and Configuration

Set the `GIANT_BOMB_API_KEY` environment variable
an API key is required.

Set the `FOUR_LUCHA_CACHE_LIMIT` environment variable
to change the cache size.

## Structure and Usage

#### Resources

Most resources are structured like so:

The API can be queried from `FourLucha.Foo` with `get/1` or `get!/1`

```elixir
# example for single resource
FourLucha.Game.get(1)
# {:ok, FourLucha.Resource.Game, FourLucha.Resource.Response}
# {:error, FourLucha.Resource.Response}


# example for multiple resources
FourLucha.Game.get(%{ filter: [name: "Super Mario"]})
# {:ok, [FourLucha.Resource.Game ...], FourLucha.Resource.Response}

# get!/1 would return just FourLucha.Resource.Game or [FourLucha.Resource.Game ...]
```

When querying for multiple resources there are 4 fields to query with
`[:filter, :sort, :limit, :offset]`

```elixir
FourLucha.Game.get(%{
  filter: [name: "Kingdom Hearts"],
  sort: [field: "original_release_date", direction: "asc"],
  limit: 10, # defaults to 100
  offset: 5
})
```
Date fields can be filtered by date or date range:

```elixir
# Date.to_iso8601 can be used to format
FourLucha.Game.get(%{filter: [
  name: "Super Metroid",
  original_release_date: "2000-03-19"
]})

FourLucha.Game.get(%{filter: [
  name: "Super Metroid",
  original_release_date: %{start: "1900-01-01", end: "1931-12-31"}
]})
```

#### Search

Search works similarly to other endpoint but returns a map with a `:resource_type` key to specify what resource is returned.

When searching there are 4 fields to query with
`[:query, :resources, :limit, :page]`

```elixir
# Date.to_iso8601 can be used to format
FourLucha.Search.get(%{
  query: "Zelda Like a Fox"
  resources: ["game"],
  limit: 5, # defaults to 10
  page: 2 # works like offset but relative to limit
          # in this example it will skip games 0-4
          # and return games 5-9 from the query
})

```

## Additional Information

API Key and Documentation at:

https://www.giantbomb.com/api/

https://www.giantbomb.com/api/documentation/