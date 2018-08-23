defmodule ElixirBrainFxck do
  @moduledoc """
  Documentation for ElixirBrainFxck.
  """

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

  """
  def bf (code) do
    ops = String.graphemes(code)

    process({[0], 0, []}, ops)
  end

  def process({memory, pointer, outputs} , []) do
    IO.inspect outputs
    outputs
  end

  def process({memory, pointer, outputs} , [h|tail]) do
    bf_main({memory, pointer, outputs}, h)
    |> process(tail)
  end

  def bf_main({memory, pointer, outputs}, op) do
    case op do
      ">" -> 
        pointer_ = pointer + 1
        memory_ = case List.pop_at(memory, pointer_) do
          {nil, _} -> memory ++ [0]
          _ -> memory
        end
        {memory_, pointer_, outputs}
      "<" -> 
        {memory, pointer - 1, outputs}
      "+" -> 
        memory_ = List.update_at(memory, pointer, &(&1 + 1))
        {memory_, pointer, outputs}
      "-" -> 
        memory_ = List.update_at(memory, pointer, &(&1 - 1))
        {memory_, pointer, outputs}
      "." -> 
        {target, _} = List.pop_at(memory, pointer)
        {memory, pointer, outputs ++ [target]}
    end
  end
end
