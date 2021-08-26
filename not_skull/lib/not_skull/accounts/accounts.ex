#---
# Excerpted from "Testing Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/lmelixir for more book information.
#---
defmodule MyApp.Accounts do
  @moduledoc false
  alias MyApp.Repo
  alias MyApp.Accounts.User
  alias MyApp.ExternalServices.Email

  def create_user(params, emailer \\ Email) do
    result =
      params
      |> User.create_changeset()
      |> Repo.insert()

    case result do
      {:ok, new_user} ->
        :ok = emailer.send_welcome(new_user)
        {:ok, new_user}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
