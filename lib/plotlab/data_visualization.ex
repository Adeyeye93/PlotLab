defmodule Plotlab.DataVisualization do
  @moduledoc """
  The DataVisualization context.
  """

  import Ecto.Query, warn: false
  alias Plotlab.Repo

  alias Plotlab.DataVisualization.Plot

  @doc """
  Returns the list of plots.

  ## Examples

      iex> list_plots()
      [%Plot{}, ...]

  """
 def list_plots(current_user) do
  Repo.all(from p in Plot, where: p.user_id == ^current_user.id)
end



  @doc """
  Gets a single plot.

  Raises `Ecto.NoResultsError` if the Plot does not exist.

  ## Examples

      iex> get_plot!(123)
      %Plot{}

      iex> get_plot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plot!(id) do
    Repo.get!(Plot, id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a plot.

  ## Examples

      iex> create_plot(%{field: value})
      {:ok, %Plot{}}

      iex> create_plot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plot(attrs \\ %{}, current_user) do
    %Plot{}
    |> Plot.changeset(attrs, current_user)
    |> Repo.preload(:user)
    |> Repo.insert()
  end

  @doc """
  Updates a plot.

  ## Examples

      iex> update_plot(plot, %{field: new_value})
      {:ok, %Plot{}}

      iex> update_plot(plot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plot(%Plot{} = plot, attrs, current_user) do
    plot
    |> Plot.changeset(attrs, current_user)
    |> Repo.preload(:user)
    |> Repo.update()
  end

  @doc """
  Deletes a plot.

  ## Examples

      iex> delete_plot(plot)
      {:ok, %Plot{}}

      iex> delete_plot(plot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plot(%Plot{} = plot) do
    Repo.delete(plot)
    |> Repo.preload(:user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plot changes.

  ## Examples

      iex> change_plot(plot)
      %Ecto.Changeset{data: %Plot{}}

  """
  def change_plot(%Plot{} = plot, attrs \\ %{}, current_user) do
    Plot.changeset(plot, attrs, current_user)
  end
end
