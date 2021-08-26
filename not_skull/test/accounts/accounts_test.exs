#---
# Excerpted from "Testing Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/lmelixir for more book information.
#---
defmodule MyApp.AccountsTest do
  use MyApp.DataCase
  alias Ecto.Changeset

  describe "create_user/1" do
    test "success: it creates and returns a user when given valid params" do
      params = Factory.string_params(:user)
      test_pid = self()

      function_double = fn user ->
        send(test_pid, {:user, user})
        :ok
      end

      assert {:ok, %User{} = returned_user} =
               Accounts.create_user(params, function_double)

      user_from_db = Repo.get(User, returned_user.id)

      assert user_from_db == returned_user

      assert_values_for(
        expected: {params, :string_keys},
        actual: user_from_db,
        fields: fields_for(User) -- db_assigned_fields(plus: [:password])
      )

      error_message = "email wasn't sent or was sent to wrong user"
      assert_receive({:user, ^returned_user}, 500, error_message)
    end
  end
end
