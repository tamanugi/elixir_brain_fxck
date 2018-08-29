defmodule ElixirBrainFxck.Memory do

  defmodule Tape do
    @size 100
    @cells for _ <- 1..@size, do: 0
    
    defstruct cells: @cells, head: 0, tmp: []
  end
  
  def start_link do
    Agent.start_link(fn -> %Tape{} end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, &(&1))
  end

  def incr do
    %Tape{cells: cells, head: head} = get()
    Agent.update(__MODULE__, fn tape -> %Tape{tape | cells: List.update_at(cells, head, &(&1 + 1))} end)
  end

  def decr do
    %Tape{cells: cells, head: head} = get()
    Agent.update(__MODULE__, fn tape -> %Tape{tape | cells: List.update_at(cells, head, &(&1 - 1))} end)
  end

  def right do
    %Tape{cells: cells, head: head} = get()
    Agent.update(__MODULE__, fn tape -> %Tape{tape | head: head + 1} end)
  end

  def left do
    %Tape{cells: cells, head: head} = get()
    Agent.update(__MODULE__, fn tape -> %Tape{tape | head: head - 1} end)
  end

  def output do
    %Tape{cells: cells, head: head, tmp: tmp} = get()
    cell = Enum.at(cells, head)
    Agent.update(__MODULE__, fn tape -> %Tape{tape | tmp: tmp ++ [cell] } end)
  end

  def init do
    Agent.update(__MODULE__, fn _ -> %Tape{} end)
  end

  def flush do
    %Tape{tmp: tmp} = get()
    tmp
  end
end