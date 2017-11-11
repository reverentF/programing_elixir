defmodule Spawn do
  import :timer, only: [sleep: 1]

  def child(parent_pid, exit_type) do
    send parent_pid, "I'm Child."
    case exit_type do
      :ok -> 0 # nothing to do
      :exit -> exit(:boom)
      :raise -> raise RuntimeError, "Child raise exception."
    end
  end

  def parent(process_type, exit_type) do
    case process_type do
      :link -> spawn_link(Spawn, :child, [self, exit_type])
      :monitor -> spawn_monitor(Spawn, :child, [self, exit_type])
    end
    IO.puts "Parent sleeping..."
    sleep(500)
    IO.puts "Parent awake!"
    parent_receive
  end

  def parent_receive do
    receive do
      msg -> IO.inspect msg
      parent_receive
      after 1000 ->
        IO.puts "Time out"
    end
  end

  def run do
    # WorkingWithMultiProcesses-3
    # parent(:link, :ok)
    # parent(:link, :exit)
    # WorkingWithMultiProcesses-4
    # parent(:link, :raise)
    # WorkingWithMultiProcesses-5
    # parent(:monitor, :ok)
    parent(:monitor, :exit)    
    # parent(:monitor, :raise)
  end
end

Spawn.run()