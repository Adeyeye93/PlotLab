defmodule PlotlabWeb.SharedLive do
  use PlotlabWeb, :live_view


  def mount(_params, _session, socket) do

    {:ok, assign(socket, page_title: :"Shared with you")}
  end
end
