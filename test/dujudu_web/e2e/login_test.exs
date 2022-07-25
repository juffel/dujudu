defmodule DujuduWeb.E2E.LoginTest do
  use DujuduWeb.E2ECase

  alias Wallaby.Query

  feature "create account and login afterwards", %{session: session} do
    session
    |> visit("/")
    |> click(Query.link("Login"))
    |> click(Query.link("Sign up here"))
    |> fill_in(Query.text_field("Email"), with: "chanandler@bong.com")
    |> fill_in(Query.text_field("Password"), with: "whatsyourfavouritecolorblue")
    |> click(Query.button("Create Account"))
    |> assert_has(Query.text("Account created"))
    |> print_page_source()
    |> click(Query.button("Logout"))
    |> assert_has(Query.text("Logged out successfully"))
    |> click(Query.link("Login"))
    |> fill_in(Query.text_field("Email"), with: "chanandler@bong.com")
    |> fill_in(Query.text_field("Password"), with: "whatsyourfavouritecolorblue")
    |> click(Query.button("Login"))
    |> assert_has(Query.text("Logged in successfully"))
    |> refute_has(Query.link("Login"))
    |> click(Query.button("Logout"))

    # check that logging in with invalid credentials errors correctly
    session
    |> visit("/")
    |> click(Query.link("Login"))
    |> fill_in(Query.text_field("Email"), with: "no@one.org")
    |> fill_in(Query.text_field("Password"), with: "definitelynotapassword")
    |> click(Query.button("Login"))
    |> assert_has(Query.text("Invalid email or password"))

    # check that creating an second account with an existing email is not possible
    session
    |> visit("/")
    |> click(Query.link("Login"))
    |> click(Query.link("Sign up here"))
    |> fill_in(Query.text_field("Email"), with: "chanandler@bong.com")
    |> fill_in(Query.text_field("Password"), with: "whatsyourfavouritecolorblue")
    |> click(Query.button("Create Account"))
    |> assert_has(Query.text("has already been taken"))
  end
end
