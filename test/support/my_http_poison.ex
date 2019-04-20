defmodule MyHttpPoison do
  def get(_uri) do
    {:ok, %HTTPoison.Response{body: "good"}}
  end
end
