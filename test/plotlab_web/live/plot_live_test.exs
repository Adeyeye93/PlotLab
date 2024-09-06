defmodule PlotlabWeb.PlotLiveTest do
  use PlotlabWeb.ConnCase

  import Phoenix.LiveViewTest
  import Plotlab.DataVisualizationFixtures

  @create_attrs %{name: "some name", dataset: "some dataset", expression: "some expression"}
  @update_attrs %{name: "some updated name", dataset: "some updated dataset", expression: "some updated expression"}
  @invalid_attrs %{name: nil, dataset: nil, expression: nil}

  defp create_plot(_) do
    plot = plot_fixture()
    %{plot: plot}
  end

  describe "Index" do
    setup [:create_plot]

    test "lists all plots", %{conn: conn, plot: plot} do
      {:ok, _index_live, html} = live(conn, ~p"/plots")

      assert html =~ "Listing Plots"
      assert html =~ plot.name
    end

    test "saves new plot", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/plots")

      assert index_live |> element("a", "New Plot") |> render_click() =~
               "New Plot"

      assert_patch(index_live, ~p"/plots/new")

      assert index_live
             |> form("#plot-form", plot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#plot-form", plot: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/plots")

      html = render(index_live)
      assert html =~ "Plot created successfully"
      assert html =~ "some name"
    end

    test "updates plot in listing", %{conn: conn, plot: plot} do
      {:ok, index_live, _html} = live(conn, ~p"/plots")

      assert index_live |> element("#plots-#{plot.id} a", "Edit") |> render_click() =~
               "Edit Plot"

      assert_patch(index_live, ~p"/plots/#{plot}/edit")

      assert index_live
             |> form("#plot-form", plot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#plot-form", plot: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/plots")

      html = render(index_live)
      assert html =~ "Plot updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes plot in listing", %{conn: conn, plot: plot} do
      {:ok, index_live, _html} = live(conn, ~p"/plots")

      assert index_live |> element("#plots-#{plot.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#plots-#{plot.id}")
    end
  end

  describe "Show" do
    setup [:create_plot]

    test "displays plot", %{conn: conn, plot: plot} do
      {:ok, _show_live, html} = live(conn, ~p"/plots/#{plot}")

      assert html =~ "Show Plot"
      assert html =~ plot.name
    end

    test "updates plot within modal", %{conn: conn, plot: plot} do
      {:ok, show_live, _html} = live(conn, ~p"/plots/#{plot}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Plot"

      assert_patch(show_live, ~p"/plots/#{plot}/show/edit")

      assert show_live
             |> form("#plot-form", plot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#plot-form", plot: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/plots/#{plot}")

      html = render(show_live)
      assert html =~ "Plot updated successfully"
      assert html =~ "some updated name"
    end
  end
end
