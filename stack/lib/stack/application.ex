defmodule Stack.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, initial_stack) do
    ## With Single SuperVisor
    # import Supervisor.Spec, warn: false

    # children = [
    #   # Starts a worker by calling: Stack.Worker.start_link(arg1, arg2, arg3)
    #   # worker(Stack.Worker, [arg1, arg2, arg3]),
    #   worker(Stack.Server, [[1,2,3]])
    # ]

    # opts = [strategy: :one_for_one, name: Stack.Supervisor]
    # Supervisor.start_link(children, opts)

    ## With Stash
    {:ok, _pid} = Stack.Supervisor.start_link(initial_stack)
  end
end
