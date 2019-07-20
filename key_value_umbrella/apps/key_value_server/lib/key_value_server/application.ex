defmodule KeyValueServer.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    port =
      String.to_integer(
        System.get_env("KEYVALUE_PORT") ||
          raise("missing $KEYVALUE_PORT environment variable")
      )

    children = [
      {Task.Supervisor, name: KeyValueServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> KeyValueServer.accept(port) end},
        restart: :permanent
      )
    ]

    opts = [strategy: :one_for_one, name: KeyValueServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
