if Code.ensure_compiled?(Ecto.Type) do
  defmodule Type.Tags do
    @moduledoc """
    Provides custom Ecto type to use comma delimited tag list.
    It might work with different adapters, but it has only been tested
    on PostgreSQL with nested type
    ## Usage:

    Schema:
        defmodule Post do
          use Ecto.Schema
          schema "posts" do
            field :title, :string
            field :body, :string
            field :tags, Data.TagType
          end
        end
    Migration:
        def change do
          create table(:posts) do
            add :title, :string
            add :body, :string
            add :tags, {:array, :string}
          end
        end
    """
    @behaviour Ecto.Type

    @spec type() :: {atom, atom}
    def type, do: {:array, :string}

    @spec cast(list(String.t) | String.t) :: {atom, list(String.t)}
    def cast(term)
    def cast(term) when is_list(term), do: {:ok, term}
    def cast(""), do: {:ok, []}
    def cast(term) when is_binary(term) do
      case get_delimiter(term) do
        :error -> :error
        delimeter -> {:ok, String.split(term, delimeter, trim: true)}
      end
    end
    def cast(_), do: :error

    @spec load(list(String.t)) :: {atom, list(String.t)}
    def load(term) when is_list(term), do: {:ok, term}

    @spec dump(list(String.t)) :: {atom, list(String.t)}
    def dump(term) when is_list(term), do: {:ok, term}
    def dump(_), do: :error

    @spec get_delimiter(String.t) :: String.t | atom
    defp get_delimiter(term) do
      cond do
        term =~ ~r/^(\w+)(,\s\w+)*$/ -> ", "
        term =~ ~r/^(\w+)(,\w+)*$/ -> ","
        true -> :error
      end
    end
  end
end
