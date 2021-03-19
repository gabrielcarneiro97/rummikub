defmodule PSetTest do
  use ExUnit.Case
  doctest PSet

  @colors [:red, :yellow, :black, :blue]

  defp all_valid_groups() do
    Enum.map(
      0..13,
      fn num ->
        %PSet{
          pieces: Enum.map(
            @colors,
            &(%Piece{ number: num, color: &1 })
          )
        }
      end
    )
  end

  defp all_valid_runs() do
    Enum.map(
      @colors,
      fn color ->
        %PSet{
          pieces: Enum.map(
            1..13,
            &(%Piece{ number: &1, color: color })
          )
        }
      end
    )
  end

  test "Valid Groups" do
    Enum.map(
      all_valid_groups(),
      fn set ->
        assert PSet.is_valid(set)
      end
    )
  end

  test "Valid Runs" do
    Enum.map(
      all_valid_runs(),
      fn set ->
        assert PSet.is_valid(set)
      end
    )
  end
end
