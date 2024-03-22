defmodule Biolex.Fasta do
  def parse(fasta) do
    [full_meta, sequence] = String.split(fasta, "\n", parts: 2)
    [name, meta] = String.split(full_meta, " ", parts: 2)
    {:ok, {String.trim(String.trim(name, ">")), String.trim(meta), sequence}}
  end
end
