defmodule Advance.Repo.Migrations.CategoryTextAndIndex do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :description, :string
    end

    create index(:categories, [:name])
  end
end
