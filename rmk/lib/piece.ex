defmodule Piece do
  defstruct [:number, :color]

  defmacro is_valid(number, color) do
    quote do
      (unquote(color) == :blue or unquote(color) == :yellow or unquote(color) == :black or unquote(color) == :red) and unquote(number) <= 13 and unquote(number) >= 0
    end
  end

  def is_valid(%Piece{} = piece), do: is_valid(piece.number, piece.color)

end
