defmodule PieceTest do
  use ExUnit.Case
  doctest Piece

  defp all_valid_pieces() do
    Enum.map(
      0..13,
      fn num ->
        [
          %Piece{ number: num, color: :red },
          %Piece{ number: num, color: :yellow },
          %Piece{ number: num, color: :black },
          %Piece{ number: num, color: :blue }
        ]
      end
    )
    |> List.flatten
  end

  test "Valid Pieces" do
    all_valid_pieces()
    |> Enum.map(fn piece -> assert Piece.is_valid(piece) end)
  end

  test "Invalid Pieces" do
    Enum.map(
      0..200,
      fn num ->
        [
          %Piece{ number: num, color: :red },
          %Piece{ number: num, color: :yellow },
          %Piece{ number: num, color: :black },
          %Piece{ number: num, color: :blue }
        ]
      end
    )
    |> List.flatten
    |> Enum.filter(fn el -> not Enum.member?(all_valid_pieces(), el) end)
    |> Enum.map(fn piece -> assert not Piece.is_valid(piece) end)
  end
end
