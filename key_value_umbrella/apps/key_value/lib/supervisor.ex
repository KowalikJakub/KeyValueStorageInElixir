defmodule KeyValue.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      { DynamicSupervisor, name: KeyValue.BucketSupervisor, strategy: :one_for_one },
      { KeyValue.Registry, name: KeyValue.Registry }
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
