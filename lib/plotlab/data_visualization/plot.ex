defmodule Plotlab.DataVisualization.Plot do
  use Plotlab.Schema
  import Ecto.Changeset

  schema "plots" do
    field :name, :string
    field :dataset, :string
    field :expression, :string
    belongs_to :user, Plotlab.Account.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plot, attrs, current_user) do
    plot
    |> cast(attrs, [:name, :dataset, :expression])
    |> put_assoc(:user, current_user)
    |> validate_required([:name, :dataset, :expression])
  end
end
