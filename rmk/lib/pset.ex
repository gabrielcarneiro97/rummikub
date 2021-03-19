defmodule PSet do
  require Piece

  defstruct [:pieces]

  def is_valid(set, pieces \\ nil, piece \\ nil, piece_pos \\ nil, expected \\ nil, valid_size \\ nil, type \\ nil, valid_pieces_variety \\ nil)

  # validate size
  def is_valid(set, pieces, piece, piece_pos, expected, nil, type, valid_pieces_variety) do
    is_valid(set, pieces, piece, piece_pos, expected, valid_size(length(set.pieces)), type, valid_pieces_variety)
  end
  def is_valid(_, _, _, _, _, false, _, _), do: false

  # define type and validate pieces variety
  def is_valid(%PSet{} = set, pieces, piece, piece_pos, expected, true, nil, nil) do
    sets = Enum.reduce(
      set.pieces,
      %{colors: MapSet.new(), numbers: MapSet.new()},
      fn el, acc ->
        %{
          colors: MapSet.put(acc.colors, el.color),
          numbers: MapSet.put(acc.numbers, el.number)
        }
      end
    )
    colors_qnt = Enum.filter(sets.colors, fn el -> el != 0 end) |> length
    numbers_qnt = Enum.filter(sets.numbers, fn el -> el != 0 end) |> length

    type = def_type(colors_qnt)
    vpv = valid_pieces_variety(numbers_qnt, type)

    is_valid(set, pieces, piece, piece_pos, expected, true, type, vpv);
  end
  def is_valid(_, _, _, _, _, _, _, false), do: false

  def is_valid(set, _, _, _, _, true, :grp, true) when is_list(set.pieces) do
    colors_variety = Enum.reduce(set.pieces, MapSet.new(), fn el, acc -> MapSet.put(acc, el.color) end) |> MapSet.size
    colors_variety == length(set.pieces)
  end

  def is_valid(set, nil, nil, nil, expected, true, :run, true) do
    [piece | pieces] = set.pieces
    is_valid(set, pieces, piece, 0, expected, true, :run, true)
  end

  def is_valid(_, _, %Piece{} = piece, _, _, true, :run, true) when (not Piece.is_valid(piece.number, piece.color)), do: false
  def is_valid(_, _, %Piece{} = piece, piece_pos, _, true, :run, true) when piece.number != 0 and piece.number > piece_pos + 1, do: false
  def is_valid(_, _, _, _, %Piece{} = expected, true, :run, true) when expected.number > 13, do: false

  def is_valid(set, pieces, %Piece{ number: 0 }, piece_pos, nil, true, :run, true) do
    [new_piece | new_piecies] = pieces
    is_valid(set, new_piecies, new_piece, piece_pos + 1, nil, true, :run, true)
  end

  def is_valid(set, pieces, %Piece{ number: 0 }, piece_pos, %Piece{} = expected, true, :run, true) do
    [new_piece | new_piecies] = pieces
    new_expected = %Piece{expected | number: expected.number + 1}
    is_valid(set, new_piecies, new_piece, piece_pos + 1, new_expected, true, :run, true)
  end

  def is_valid(_, _, %Piece{} = piece, _, %Piece{} = expected, true, :run, true) when piece.number != expected.number or expected.number > 13, do: false
  def is_valid(_, [], _, _, _, true, _, true), do: true

  def is_valid(%PSet{} = set, pieces, %Piece{} = piece, piece_pos, _, true, :run, true) do
    [new_piece | new_piecies] = pieces
    new_expected = %Piece{piece | number: piece.number + 1}
    is_valid(set, new_piecies, new_piece, piece_pos + 1, new_expected, true, :run, true)
  end

  def is_valid(_, _, _, _, _, _, _, _), do: false

  defp valid_size(size) when size >= 3, do: true
  defp valid_size(_), do: false

  defp valid_pieces_variety(qnt, :grp) when qnt == 1 or qnt == 0, do: true
  defp valid_pieces_variety(qnt, :run) when qnt >= 3 and qnt <= 13, do: true
  defp valid_pieces_variety(_, _), do: false

  defp def_type(qnt) when qnt == 1 or qnt == 0, do: :run
  defp def_type(_), do: :grp
end
