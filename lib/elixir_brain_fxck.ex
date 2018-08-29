defmodule ElixirBrainFxck do
  @moduledoc """
  Documentation for ElixirBrainFxck.
  """

  alias ElixirBrainFxck.Memory

  @opertors [
    "+",
    "-",
    ">",
    "<",
    "[",
    "]",
    "."
  ]

  @doc """
  Brain Fxxk!!!.

  ## Examples

      iex> ElixirBrainFxck.bf "+++."
      [3]
      iex> ElixirBrainFxck.bf "+++.+."
      [3,4]
      iex> ElixirBrainFxck.bf "++.>+."
      [2, 1]
      iex> ElixirBrainFxck.bf "++.>+.<."
      [2, 1, 2]
      iex> ElixirBrainFxck.bf "+++[>++++<-]>."
      [12]

  """
  def bf(code) do
    Memory.start_link
    Memory.init()

    code
    |> String.graphemes
    |> Enum.filter(fn x -> Enum.member?(@opertors, x) end)
    |> process
  end

  def process([]) do
    Memory.flush()
  end

  def process([op | tail]) do
    case op do
      ">" -> 
        Memory.right()
      "<" -> 
        Memory.left()
      "+" -> 
        Memory.incr()
      "-" -> 
        Memory.decr()
      "." -> 
        Memory.output()
    end

    process(tail)
  end
end
