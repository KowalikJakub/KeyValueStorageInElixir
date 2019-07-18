defmodule KeyValue do
  @moduledoc """
  Documentation for KeyValue.
  """

  use Application

  def start(_type, _args) do
    KeyValue.Supervisor.start_link(name: KeyValue.Supervisor)
  end
end
