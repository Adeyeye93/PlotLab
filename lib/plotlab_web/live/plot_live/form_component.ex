defmodule PlotlabWeb.PlotLive.FormComponent do
  use PlotlabWeb, :live_component

  alias Plotlab.DataVisualization

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage plot records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="plot-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:dataset]} type="text" label="Dataset" />
        <.input field={@form[:expression]} type="text" label="Expression" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Plot</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{plot: plot} = assigns, socket) do
    current_user = assigns.current_user
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(DataVisualization.change_plot(plot, current_user))
     end)}
  end

  @impl true
  def handle_event("validate", %{"plot" => plot_params}, socket) do
    current_user = socket.assigns.current_user
    changeset = DataVisualization.change_plot(socket.assigns.plot, plot_params, current_user)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"plot" => plot_params}, socket) do
    save_plot(socket, socket.assigns.action, plot_params)
  end

  defp save_plot(socket, :edit, plot_params) do
    current_user = socket.assigns.current_user
    case DataVisualization.update_plot(socket.assigns.plot, plot_params, current_user) do
      {:ok, plot} ->
        notify_parent({:saved, plot})

        {:noreply,
         socket
         |> put_flash(:info, "Plot updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_plot(socket, :new, plot_params) do
    current_user = socket.assigns.current_user
    case DataVisualization.create_plot(plot_params, current_user) do
      {:ok, plot} ->
        notify_parent({:saved, plot})

        {:noreply,
         socket
         |> put_flash(:info, "Plot created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
