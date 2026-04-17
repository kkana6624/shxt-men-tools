defmodule ShxtMenToolsWeb.UserLive.Invitation do
  use ShxtMenToolsWeb, :live_view

  alias ShxtMenTools.Accounts
  alias ShxtMenTools.Accounts.User

  on_mount {ShxtMenToolsWeb.UserAuth, :require_admin}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm pt-10">
        <div class="text-center mb-8">
          <.header>
            <h1 class="text-3xl font-extrabold bg-clip-text text-transparent bg-gradient-to-r from-primary to-accent">
              Invite New User
            </h1>
            <:subtitle>
              Invite a new user to the system.
            </:subtitle>
          </.header>
        </div>

        <div class="card bg-base-100 shadow-xl border border-base-200 transition-all hover:shadow-2xl hover:border-primary/30">
          <div class="card-body p-6 sm:p-8">
            <.form
              for={@form}
              id="invitation-form"
              phx-submit="save"
              phx-change="validate"
              class="space-y-5"
            >
              <div class="group">
                <.input
                  field={@form[:email]}
                  type="email"
                  label="Email"
                  required
                  spellcheck="false"
                />
              </div>
              <div class="group">
                <.input
                  field={@form[:password]}
                  type="password"
                  label="Initial Password"
                  required
                />
              </div>
              <div class="group">
                <.input
                  field={@form[:role]}
                  type="select"
                  label="Role"
                  options={[{"User", "user"}, {"Administrator", "admin"}]}
                  required
                />
              </div>

              <div class="pt-4">
                <.button
                  phx-disable-with="Inviting..."
                  class="btn btn-primary w-full text-base shadow-md h-12 transition-transform hover:-translate-y-0.5 active:translate-y-0 active:scale-95"
                >
                  Send Invitation
                </.button>
              </div>
            </.form>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_invitation(%User{role: "user"})
    {:ok, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_invitation(%User{}, user_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.invite_user(user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User #{user.email} invited successfully.")
         |> push_navigate(to: ~p"/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
