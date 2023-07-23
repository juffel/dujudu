defmodule DujuduWeb.ErrorHTML do
  use DujuduWeb, :html

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/hello_web/controllers/error_html/404.html.heex
  #   * lib/hello_web/controllers/error_html/500.html.heex
  #
  # embed_templates "error_html/*"

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
