defmodule Blurble.Repo.Migrations.AddEmailAndConstraintsToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :email, :string
      modify :username, :string, null: false
      modify :password, :string, null: false
    end

    create index("users", [:username], unique: true)
    create index("users", [:email], unique: true)
  end
end
