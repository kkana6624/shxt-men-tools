alias ShxtMenTools.Accounts
alias ShxtMenTools.Repo
alias ShxtMenTools.Accounts.User

# Admin creation
admin_email = "administrator@example.com"
unless Repo.get_by(User, email: admin_email) do
  Accounts.register_user(%{
    email: admin_email,
    password: "P@sswordAD01",
    role: "admin"
  })
end

# Initial user accounts creation
Enum.each(1..3, fn i ->
  email = "user#{i}@example.com"
  unless Repo.get_by(User, email: email) do
    Accounts.invite_user(%{
      email: email,
      password: "P@sswordUSR0#{i}",
      role: "user"
    })
  end
end)
