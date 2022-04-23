defmodule Videoroom.NotifyRoom do
  use GenServer

  def start(init_arg, opts) do
    GenServer.start(__MODULE__, init_arg, opts)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @impl true
  def init(notify_room_id) do
    {:ok, %{notify_room_id: notify_room_id, peer_channels: [], peer_length: 0}}
  end

  @impl true
  def handle_info({:join_notify_channel, peer_channel_pid}, state) do
    peer_channels = state.peer_channels

    peer_channels = List.insert_at(peer_channels, 0, peer_channel_pid)
    IO.inspect peer_channels
    state = put_in(state, [:peer_channels], peer_channels)
    IO.inspect state.peer_channels


    peer_length_in_room_active = state.peer_length
    Process.monitor(peer_channel_pid)
    if peer_length_in_room_active > 0 do
      "notify_" <> room_id = state.notify_room_id
      send(peer_channel_pid, {:room_active, peer_length_in_room_active, room_id})
    end

    {:noreply, state}
  end

  @impl true
  def handle_info({:room_active, peer_length}, state) do
    state = put_in(state, [:peer_length], peer_length)
    "notify_" <> room_id = state.notify_room_id
    for pid <- state.peer_channels, do: send(pid, {:room_active, peer_length, room_id})

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    peer_channel_pid =
      state.peer_channels
      |> Enum.find(fn peer_channel_pid -> peer_channel_pid == pid end)

    peer_channels = List.delete(state.peer_channels, peer_channel_pid)
    peer_length = state.peer_length - 1
    state = put_in(state, [:peer_channels], peer_channels)
          |> put_in([:peer_length], peer_length)

    {:noreply, state}
  end

end
