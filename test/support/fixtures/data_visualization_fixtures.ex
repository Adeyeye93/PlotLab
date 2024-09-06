defmodule Plotlab.DataVisualizationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Plotlab.DataVisualization` context.
  """

  @doc """
  Generate a plot.
  """
  def plot_fixture(attrs \\ %{}) do
    {:ok, plot} =
      attrs
      |> Enum.into(%{
        dataset: "some dataset",
        expression: "some expression",
        name: "some name"
      })
      |> Plotlab.DataVisualization.create_plot()

    plot
  end
end
