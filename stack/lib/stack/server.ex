# exercise : OTP-Servers
defmodule Stack.Server do
  use GenServer

  # OTP-Servers-4
  def start_link(initial_stack) do
    GenServer.start_link(__MODULE__, initial_stack, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)    
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})    
  end

  # OTP-Servers-5
  def terminate(reason, state) do
    IO.puts("Server terminated. reason: #{reason}")
    IO.puts("                   state: #{state}")
  end

  def handle_call(:pop, from, stack_list = []) do
    {:stop, "pop: stack is empty.", stack_list}
  end

  # OTP-Servers-1
  def handle_call(:pop, from, stack_list = [head|tail]) do
    {:reply, head, tail}
  end
  
  # OTP-Servers-2
  def handle_cast({:push, value}, stack_list) do
    {:noreply, [value] ++ stack_list}
  end
  
end