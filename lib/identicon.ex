defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  # get the first 3 values and throw away the rest from Identicon.Image {hex: [55, 55, 55, ....etc]}
  # pattern matching r,g,b out of image while recieving image as an argument at the same time
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # add color key/value pair to the struct with pipe, adding in rgb
    %Identicon.Image{image | color: {r, g, b}}
  end
end
