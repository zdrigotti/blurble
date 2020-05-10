defmodule BlurbleWeb.Protected do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>This is a sample protected route liveview. Counter: <%= @counter %></div>
    <div>
      <button phx-click="test_button">Test Button</button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: 0)}
  end

  def handle_event("test_button", _value, socket) do
    {:noreply, assign(socket, counter: socket.assigns.counter + 1)}
  end
end
