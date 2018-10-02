defmodule Identicon do
  @moduledoc """
    Takes in a string input and creates an image based on that string.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  @doc """
  Takes a string `input` and hashes it, turning it to a list afterwards.
  returns `Identicon.Image` updated with the hashed list as the hex value
  ## Examples
    iex> Identicon.hash_input("hello")
    %Identicon.Image{
    color: nil,
    hex: [93, 65, 64, 42, 188, 75, 42, 118, 185, 113, 157, 145, 16, 23, 197, 146]
    }
  """
  @spec hash_input(String.t()) :: Identicon.Image.t()
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  @doc """
    pattern matching r,g,b out of Identicon.Image while recieving image as an argument at the same time
    add r,g,b colors as tuples to the struct with pipe
    ## Examples
      iex> image = Identicon.hash_input("hello")
      iex> Identicon.pick_color(image)
      %Identicon.Image{
      color: {93, 65, 64},
      hex: [93, 65, 64, 42, 188, 75, 42, 118, 185, 113, 157, 145, 16, 23, 197, 146]
      }
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end
end
