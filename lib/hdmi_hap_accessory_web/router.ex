defmodule HdmiHapAccessoryWeb.Router do
  use HdmiHapAccessoryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HdmiHapAccessoryWeb do
    pipe_through :api
  end
end
