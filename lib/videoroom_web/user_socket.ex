defmodule VideoRoomWeb.UserSocket do
  use Phoenix.Socket

  channel("room:*", VideoRoomWeb.PeerChannel)
  channel("room_notify:*", VideoRoomWeb.NotifyChannel)

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
