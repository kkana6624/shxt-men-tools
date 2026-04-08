defmodule ShxtMenToolsWeb.UserLive.Login do
  use ShxtMenToolsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm pt-10">
        <div class="text-center mb-8">
          <.header>
            <h1 class="text-3xl font-extrabold bg-clip-text text-transparent bg-gradient-to-r from-primary to-accent">
              Welcome Back
            </h1>
            <:subtitle>
              <%= if @current_scope do %>
                You need to reauthenticate to perform sensitive actions on your account.
              <% else %>
                <p class="text-base-content/70">Please enter your credentials to log in.</p>
              <% end %>
            </:subtitle>
          </.header>
        </div>

        <div class="card bg-base-100 shadow-xl border border-base-200 transition-all hover:shadow-2xl hover:border-primary/30">
          <div class="card-body p-6 sm:p-8">
            <.form
              :let={f}
              for={@form}
              id="login_form_password"
              action={~p"/users/log-in"}
              phx-submit="submit_password"
              phx-trigger-action={@trigger_submit}
              class="space-y-5"
            >
              <div class="group">
                <.input
                  readonly={!!@current_scope}
                  field={f[:email]}
                  type="text"
                  label="Email"
                  autocomplete="username"
                  spellcheck="false"
                  required
                />
              </div>
              <div class="group">
                <.input
                  field={@form[:password]}
                  type="password"
                  label="Password"
                  autocomplete="current-password"
                  spellcheck="false"
                  required
                />
              </div>
              
    <!-- Hidden remember me -->
              <input type="hidden" name={@form[:remember_me].name} value="true" />

              <div class="pt-4">
                <.button
                  class="btn btn-primary w-full text-base shadow-md h-12 transition-transform hover:-translate-y-0.5 active:translate-y-0 active:scale-95"
                  name={@form[:remember_me].name}
                  value="true"
                >
                  Log in <span aria-hidden="true" class="ml-1">→</span>
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
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end
end
