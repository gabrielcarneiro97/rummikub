defmodule Piece do
  defstruct [:number, :color]

  @spec is_valid(Piece) :: boolean
  def is_valid(piece) when piece.number <= 13 and piece.number >= 0, do: check_color(piece.color)
  def is_valid(_), do: false

  defp check_color(:blue), do: true
  defp check_color(:yellow), do: true
  defp check_color(:black), do: true
  defp check_color(:red), do: true
  defp check_color(_), do: false
end

defmodule PSet do
  defstruct [:pieces]

  def is_valid(set, pieces \\ nil, piece \\ nil, piece_pos \\ nil, expected \\ nil, valid_size \\ nil, type \\ nil, valid_pieces_variety \\ nil)

  # validate size
  def is_valid(set, pieces, piece, piece_pos, expected, nil, type, valid_pieces_variety) do
    is_valid(set, pieces, piece, piece_pos, expected, valid_size(length(set.pieces)), type, valid_pieces_variety)
  end
  def is_valid(_, _, _, _, _, false, _, _), do: false

  # define type and validate pieces variety
  def is_valid(%PSet{} = set, [%Piece{}] = pieces, piece, piece_pos, expected, true, nil, nil) do
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
    colors_qnt = MapSet.size(sets.colors)
    numbers_qnt = Enum.filter(sets.numbers, fn el -> el != 0 end) |> length

    type = def_type(colors_qnt)
    vpv = valid_pieces_variety(numbers_qnt, type)

    is_valid(set, pieces, piece, piece_pos, expected, true, type, vpv);
  end
  def is_valid(_, _, _, _, _, _, _, false), do: false

  def is_valid(set, nil, nil, nil, expected, true, type, true) when is_atom(type) do
    [piece | pieces] = set.pieces
    is_valid(set, pieces, piece, 0, expected, true, type, true)
  end

  def is_valid(_, [%Piece{}] = pieces, _, _, _, true, :grp, true) do
    colors_variety = Enum.reduce(pieces, MapSet.new(), fn el, acc -> MapSet.put(acc, el.color) end) |> MapSet.size
    colors_variety == length(pieces)
  end

  def is_valid(_, _, %Piece{} = piece, piece_pos, _, true, :run, true) when piece.number != 0 and piece.number > piece_pos, do: false
  def is_valid(_, _, _, _, %Piece{} = expected, true, :run, true) when expected.number > 13, do: false

  def is_valid(set, pieces, %Piece{ number: 0 }, piece_pos, nil, true, :run, true) do
    [new_piece | new_piecies] = pieces
    is_valid(set, new_piecies, new_piece, piece_pos + 1, nil, true, :run, true)
  end

  def is_valid(set, pieces, %Piece{ number: 0 }, piece_pos, %Piece{} = expected, true, :run, true) do
    [new_piece | new_piecies] = pieces
    new_expected = %Piece{number: expected.number + 1, color: expected.color}
    is_valid(set, new_piecies, new_piece, piece_pos + 1, new_expected, true, :run, true)
  end

  def is_valid(%PSet{} = set, [%Piece{}] = pieces, %Piece{} = piece, piece_pos, nil, true, :run, true) do
    [new_piece | new_piecies] = pieces
    new_expected = %Piece{number: piece.number + 1, color: piece.color}
    is_valid(set, new_piecies, new_piece, piece_pos + 1, new_expected, true, :run, true)
  end

  def is_valid(_, [%Piece{}], %Piece{} = piece, _, %Piece{} = expected, true, :run, true) when piece.number != expected.number or expected > 13 do
    false
  end

  def is_valid(_, [], _, _, _, true, _, true), do: true

  def is_valid(_, _, _, _, _, _, _, _), do: false

  defp valid_size(size) when size >= 3, do: true
  defp valid_size(_), do: false

  defp valid_pieces_variety(1, :grp), do: true
  defp valid_pieces_variety(qnt, :run) when qnt >= 3 and qnt <= 13, do: true
  defp valid_pieces_variety(_, _), do: false

  defp def_type(1), do: :run
  defp def_type(_), do: :grp
end
