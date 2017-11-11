defmodule Spawn do
import :timer, only: [sleep: 1]
  def child(trap_flag) do
    Process.flag(:trap_exit, trap_flag)
    spawn_link(Spawn, :child_death, [])
    receive do
      msg -> IO.puts "Child : Message Received - #{inspect msg}"
    after 1000 ->
      IO.puts "Child: Nothing Received"
    end
  end

  def child_death do
    sleep 500
    exit(:boom)
  end

  def parent(trap_flag) do
    Process.flag(:trap_exit, trap_flag)
    spawn_link(Spawn, :child_death, [])
    receive do
      msg -> IO.puts "Parent: Message Received - #{inspect msg}"
    after 1000 ->
      IO.puts "Parent: Nothing Received"
    end
  end

  def parent_death(child_trap_flag) do
    spawn_link(Spawn, :child, [child_trap_flag])
    sleep 500
    exit(:boom)
  end

  def run() do
    # parent(true)
    # parent(false)
    # parent_death(true)
    parent_death(false)
  end
end

Spawn.run()