defmodule Type.ExternalID do
  @behaviour Ecto.Type

  @spec type() :: atom
  def type, do: :string

  @spec cast(Integer.t | String.t) :: {atom, String.t}
  def cast(term)
  def cast(term) when is_integer(term), do: term |> to_string() |> cast()
  def cast(term) when is_binary(term), do: {:ok, term}
  def cast(_), do: :error

  @spec load(String.t) :: {atom, String.t}
  def load(term) when is_binary(term), do: {:ok, term}
  def load(_), do: :error

  @spec dump(String.t) :: {atom, list(String.t)}
  def dump(term) when is_binary(term), do: {:ok, term}
  def dump(_), do: :error
end
