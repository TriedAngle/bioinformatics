defmodule Biolex.Fasta do
  defstruct name: nil, meta: nil, sequence: nil

  def parse(fasta, strip_newlines \\ false) do
    [full_meta, sequence] = String.split(fasta, "\n", parts: 2)
    [name, meta] = String.split(full_meta, " ", parts: 2)

    sequence = if strip_newlines do String.replace(sequence, "\n", "") else sequence end

    {
      :ok,
      %Biolex.Fasta{
        name: name |> String.trim(">") |> String.trim(),
        meta: meta |> String.trim(),
        sequence: sequence |> String.trim(),
      }
    }
  end

  def to_string(%Biolex.Fasta{name: name, meta: meta, sequence: sequence}, n \\ 0) do
    formatted = if n > 0 do
      sequence
      |> String.graphemes()
      |> Enum.chunk_every(n)
      |> Enum.join("\n")
    else
      sequence
    end

    "> #{name} #{meta}\n#{formatted}\n"
  end
end
