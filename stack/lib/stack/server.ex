# exercise : OTP-Servers
defmodule Stack.Server do
  use GenServer


  #####
  # API

  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)    
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})    
  end

  #####
  # Callback functions of GenServer

  def init(stash_pid) do
    stack_list = Stack.Stash.get_value stash_pid
    {:ok, {stack_list, stash_pid}}
  end

  # def handle_call(:pop, from, stack_list = []) do
  #   {:stop, "pop: stack is empty.", stack_list}
  # end

  def handle_call(:pop, _from, {stack_list, stash_pid}) do
    [head|tail] = stack_list
    {:reply, head, {tail, stash_pid}}
  end
  
  # OTP-Servers-2
  def handle_cast({:push, value}, {stack_list, stash_pid}) do
    new_stack_list = [value] ++ stack_list
    {:noreply, {new_stack_list, stash_pid}}
  end

  def terminate(reason, state) do
    ## OTP-Servers-5
    # IO.puts("Server terminated. reason: #{reason}")
    # IO.puts("                   state: #{state}")
    {stack_list, stash_pid} = state
    Stack.Stash.save_value stash_pid, stack_list
  end
  
end