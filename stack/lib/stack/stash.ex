defmodule Stack.Stash do
  use GenServer

  #####
  # API

  def start_link(stack_list) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, stack_list)
  end

  def save_value(pid, value) do
    GenServer.cast pid, {:save_value, value}
  end

  def get_value(pid) do
    GenServer.call pid, :get_value
  end

  #####
  # Callback functions of GenServer

  def handle_call(:get_value, _from, current_value) do
    {:reply, current_value, current_value}
  end

  def handle_cast({:save_value, value}, _current_value) do
    {:noreply, value}
  end
end