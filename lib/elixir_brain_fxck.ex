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
      iex> ElixirBrainFxck.bf "+++++++++[>++++++++>+++++++++++>+++++<<<-]>.>++.+++++++..+++.>-.------------.<++++++++.--------.+++.------.--------.>+."
      'Hello, world!'

  """
  def bf(code) do
    Memory.start_link
    Memory.init()

    op_list = code
    |> String.graphemes
    |> Enum.filter(fn x -> Enum.member?(@opertors, x) end)

    process({op_list, 0})
  end

  def process({op_list, op_head})  do
    case Enum.at(op_list, op_head) |> operation({op_list, op_head}) do
      {:ok, op} -> process(op)
      :end -> Memory.flush
    end
  end

  def operation(">", {op_list, op_head}) do
    Memory.right()
    {:ok, {op_list, op_head + 1}}
  end

  def operation("<", {op_list, op_head}) do
    Memory.left()
    {:ok, {op_list, op_head + 1}}
  end

  def operation("+", {op_list, op_head}) do
    Memory.incr()
    {:ok, {op_list, op_head + 1}}
  end

  def operation("-", {op_list, op_head}) do
    Memory.decr()
    {:ok, {op_list, op_head + 1}}
  end

  def operation(".", {op_list, op_head}) do
    Memory.output()
    {:ok, {op_list, op_head + 1}}
  end

  def operation("[", {op_list, op_head}) do
    case Memory.read() do
      0 -> 
        {:ok, jump_end({op_list, op_head + 1}, 1)}
      _ ->
        {:ok, {op_list, op_head + 1}}
    end
  end

  def operation("]", {op_list, op_head}) do
    case Memory.read() do
      0 -> 
        {:ok, {op_list, op_head + 1}}
      _ ->
        {:ok, jump_begin({op_list, op_head - 1}, 1)}
    end
  end

  def operation(_, _) do
    :end
  end

  def jump_begin({op_list, op_head}, 0) do
    {op_list, op_head + 1}
  end

  def jump_begin({op_list, op_head}, s) do
    case Enum.at(op_list, op_head) do
      "[" -> jump_begin({op_list, op_head - 1}, s - 1)
      "]" -> jump_begin({op_list, op_head - 1}, s + 1)
      _   -> jump_begin({op_list, op_head - 1}, s)
    end
  end

  def jump_end({op_list, op_head}, 0) do
    {op_list, op_head}
  end

  def jump_end({op_list, op_head}, s) do
    case Enum.at(op_list, op_head) do
      "[" -> jump_end({op_list, op_head + 1}, s + 1)
      "]" -> jump_end({op_list, op_head + 1}, s - 1)
      _   -> jump_end({op_list, op_head + 1}, s)
    end
  end
end
