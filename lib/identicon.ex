defmodule Identicon do
  @moduledoc """
    Takes in a string input and creates an image based on that string.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Takes a string `input` and hashes it, turning it to a list afterwards.
  returns `Identicon.Image` updated with the hashed list as the hex value.
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
    add r,g,b colors as tuples to the struct with pipe.
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

  @doc """
    Takes in an `Identicon.Image` without a grid and uses the `hex` value to create a grid with mirrored rows.
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Takes a list of 3 elements and returns a list of 5,  mirrored.
    ## Examples
      iex> Identicon.mirror_row([145,46,200])
      [145, 46, 200, 46, 145]
  """
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
    Takes in `Identicon.Image` and filters out odd numbers from the grid, returns updated `Identicon.Image`.
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _i} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Takes in `Identicon.Image` and creates a pixel_map based on the grid, returns updated `Identicon.Image`.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Takes in the color and pixel map from `Identicon.Image` and draws an image using those values, returns a .png image.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
  Saves the .png image file using the input name.
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
