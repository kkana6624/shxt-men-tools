# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ShxtMenTools.Repo.insert!(%ShxtMenTools.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ShxtMenTools.Accounts

Accounts.register_user(%{
  email: "administrator@example.com",
  password: "P@sswordAD01"
})
