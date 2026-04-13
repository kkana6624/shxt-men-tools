defmodule ShxtMenTools.AccountsInvitationTest do
  use ShxtMenTools.DataCase

  alias ShxtMenTools.Accounts

  import ShxtMenTools.AccountsFixtures

  describe "invite_user/1" do
    test "invites a user and confirms them immediately" do
      email = unique_user_email()
      password = valid_user_password()
      role = "user"

      {:ok, user} = Accounts.invite_user(%{
        email: email,
        password: password,
        role: role
      })

      assert user.email == email
      assert user.role == role
      assert user.confirmed_at != nil
      assert Accounts.get_user_by_email_and_password(email, password)
    end

    test "invites an admin user" do
      email = unique_user_email()
      password = valid_user_password()
      role = "admin"

      {:ok, user} = Accounts.invite_user(%{
        email: email,
        password: password,
        role: role
      })

      assert user.role == "admin"
    end

    test "validates required role" do
      email = unique_user_email()
      password = valid_user_password()

      {:error, changeset} = Accounts.invite_user(%{
        email: email,
        password: password
      })

      assert %{role: ["can't be blank"]} = errors_on(changeset)
    end

    test "validates role inclusion" do
      email = unique_user_email()
      password = valid_user_password()

      {:error, changeset} = Accounts.invite_user(%{
        email: email,
        password: password,
        role: "invalid"
      })

      assert %{role: ["is invalid"]} = errors_on(changeset)
    end
  end
end
