defmodule Biolex.Env do
  def load_env(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.reject(&String.starts_with?(&1, "#"))
    |> Enum.map(&String.split(&1, "=", parts: 2))
    |> Enum.map(fn [key, value] ->
      {String.trim(key), String.trim(String.trim(value), "\"")}
    end)
    |> Enum.into(%{})
  end

  def reload(file_path) do
    env = load_env(file_path)
    set_ncbi_email(env["NCBI_EMAIL"])
    set_ncbi_key(env["NCBI_KEY"])
    {:ok, env}
  end

  def set_ncbi_email(email) do
    Application.put_env(:biolex, :ncbi_email, email)
  end

  def set_ncbi_key(key) do
    Application.put_env(:biolex, :ncbi_key, key)
  end

  def ncbi_email do
    Application.get_env(:biolex, :ncbi_email)
  end

  def ncbi_key do
    Application.get_env(:biolex, :ncbi_key)
  end
end
