defmodule KeyValue.Registry do
  use GenServer

  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, name}, _from, state) do
    {names, _} = state
    {:reply, Map.fetch(names, name), state}
  end

  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, bucket} = KeyValue.Bucket.start_link([])
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, bucket)
      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # @impl true
  # def handle_cast({:delete, bucket_name, force_delete}, buckets) do
  #   if force_delete do
  #     :ok = force_delete_bucket(bucket_name, buckets)
  #   else
  #   end
  # end

  # defp force_delete_bucket(bucket_name, buckets) do
  #   :ok
  # end


  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `bucket_name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, bucket_name) do
    GenServer.call(server, {:lookup, bucket_name})
  end

  @doc """
  Ensures there is a bucket associated with the given `bucket_name` in `server`.
  """
  def create(server, bucket_name) do
    GenServer.cast(server, {:create, bucket_name})
  end
end
