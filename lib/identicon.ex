defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  def pick_color(image) do
    # get the first 3 values and throw away the rest from Identicon.Image {hex: [55, 55, 55, ....etc]}
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    [r, g, b]
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
