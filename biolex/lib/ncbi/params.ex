defmodule Biolex.NCBI.Params do
  def new_params(), do: %{
    "email" => Biolex.Env.ncbi_email(),
    "api_key" => Biolex.Env.ncbi_key(),
    "db" => "nucleotide",
    "rettype" => "fasta",
    "retmode" => "text"
  }

  def new_params(map) do
    new_params()
    |> Map.merge(map)
  end

  def new_params(email, key) do
    new_params()
    |> Map.put("email", email)
    |> Map.put("ncbi_key", key)
  end

  def link_gene(params, gene_id, from, to, link_name) do
    Map.merge(params, %{
      "dbfrom" => from,
      "db" => to,
      "linkname" => link_name,
      "id" => gene_id,
      "retmode" => "json"
    })
  end

  def query(params, key, env) do
    Map.put(params, "query_key", key)
    |> Map.put("webenv", env)
  end

  def fasta(params) do
    Map.put(params, "retmode", "text")
    |> Map.put("rettype", "fasta")
  end

  def json(params) do
    Map.put(params, "retmode", "json")
  end

  def history(params) do
    Map.put(params, "usehistory", "y")
  end

  def database(params, db) do
    Map.put(params, "db", db)
  end

  def with_id(params, id) do
    Map.put(params, "id", id)
  end

  def max(params, value \\ 100) do
    Map.put(params, "retmax", Integer.to_string(value))
  end

  def offset(params, start \\ 0) do
    Map.put(params, "retstart", Integer.to_string(start))
  end

  def put(params, key, value) do
    Map.put(params, key, value)
  end

  def remove(params, key) do
    Map.delete(params, key)
  end

  def to_list(params) do
    Enum.map(params, fn {k, v} -> {k, to_string(v)} end)
  end
end
