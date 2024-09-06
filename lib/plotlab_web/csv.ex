defmodule PlotlabWeb.Csv do
  @local_repo_path "C:\\Users\\seyi\\Downloads\\datasets-master\\datasets-master"

  def fetch_and_parse_csv(file_name, expression) do
    file_path = Path.join(@local_repo_path, "#{file_name}.csv")

    case File.exists?(file_path) do
      true ->
        file_path
        |> File.stream!()
        |> CSV.decode(headers: true)
        |> extract_column_data(expression)

      false ->
        {:ok, "No Dataset found! "}
    end
  end

  defp extract_column_data(csv_stream, expression) do
    csv_stream
    |> Enum.each(fn
      {:ok, row} ->
        case Map.get(row, expression) do
          nil ->
            {:ok, "Expression #{expression} is not found for this dataset"}

          value ->
            {:ok, value}
        end

      {:error, _} ->
        IO.puts("Failed to parse a row in the CSV.")
    end)
  end
end
