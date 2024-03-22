defmodule Biolex.NCBI do
  alias Biolex.NCBI.Params, as: Params

  @base_url "https://eutils.ncbi.nlm.nih.gov/entrez/eutils"
  @esearch_url @base_url <> "/esearch.fcgi"
  @efetch_url @base_url <> "/efetch.fcgi"
  @esummery_url @base_url <> "/esummary.fcgi"
  @elink_url @base_url <> "/elink.fcgi"

  def get_links(gene_id, from, to, link_name) do
    params =
      Params.new_params()
      |> Params.link_gene(gene_id, from, to, link_name)

    case HTTPoison.get(@elink_url, [], params: params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = Jason.decode(body)

        ids =
          get_in(decoded, ["linksets", Access.all(), "linksetdbs", Access.all(), "links"])
          |> List.flatten()

        {:ok, ids}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to fetch link IDs. Status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{reason}"}
    end
  end

  def search(term, opts \\ []) do
    defaults =
      Params.new_params()
      |> Params.database("gene")
      |> Params.put("term", term)
      |> Params.offset()
      |> Params.history()
      |> Params.max()
      |> Params.json()

    string_opts = Enum.into(opts, %{}, fn {k, v} -> {Atom.to_string(k), v} end)

    params = Map.merge(defaults, string_opts)

    {:ok, body} = http_get(@esearch_url, [], params)
    {:ok, json} = Jason.decode(body)

    {web_env, query_key, id_list} = {
      json["esearchresult"]["webenv"],
      json["esearchresult"]["querykey"],
      json["esearchresult"]["idlist"]
    }

    {:ok, json, {web_env, query_key, id_list}}
  end

  def fetch(opts \\ []) do
    defaults =
      Params.new_params()
      |> Params.database("gene")
      |> Params.database("term")
      |> Params.fasta()

    string_opts = Enum.into(opts, %{}, fn {k, v} -> {Atom.to_string(k), v} end)

    params = Map.merge(defaults, string_opts)
    http_get(@efetch_url, [], params)
  end

  def get_sequence(id, db \\ "nucleotide") do
    params =
      Params.new_params()
      |> Params.database(db)
      |> Params.with_id(id)

    http_get(@efetch_url, [], params)
  end


  defp http_get(url, header, params) do
    case HTTPoison.get(url, header, params: params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Error: Status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{reason}"}
    end
  end

  def esearch_url, do: @esearch_url
  def efetch_url, do: @efetch_url
  def esummery_url, do: @esummery_url
  def elink_url, do: @elink_url

end
