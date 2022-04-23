defmodule VideoRoomWeb.NotifyChannel do
  use Phoenix.Channel

  @impl true
  def join("room_notify:" <> room_id, _params, socket) do
    notify_room_id = "notify_" <> room_id

    case :global.whereis_name(notify_room_id) do
      :undefined -> Videoroom.NotifyRoom.start(notify_room_id, name: {:global, notify_room_id})
      pid -> {:ok, pid}
    end
    |> case do
      {:ok, notify_room_pid} ->
        do_join(socket, notify_room_pid, notify_room_id)
      {:error, {:already_started, notify_room_pid}} ->
        do_join(socket, notify_room_pid, notify_room_id)
      {:error, _reason} ->
        {:error, %{}}
    end
  end

  defp do_join(socket, notify_room_pid, notify_room_id) do
    Process.monitor(notify_room_pid)
    send(notify_room_pid, {:join_notify_channel, self()})
    {:ok,
     Phoenix.Socket.assign(socket, %{notify_room_id: notify_room_id})}
  end

  @impl true
  def handle_info({:room_active, peer_length, room_id}, socket) do
    push(socket, "room_active", %{peer_length: peer_length, room_id: room_id})

    {:noreply, socket}
  end
end
