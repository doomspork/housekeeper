defmodule Mix.Tasks.Housekeeper.Clean do
  use Mix.Task

  alias Housekeeper.{Cleaner, Parser}

  @shortdoc "Keeps things tidy by fixing warnings for you"

  @compile_cmd 'MIX_ENV=test mix compile --force'

  def run(_args) do
    IO.puts("Looking for warnings")
    capture_compile()
    |> Parser.parse
    |> output_count
    |> Cleaner.clean

    IO.puts("Clean-up complete")
  end

  def capture_compile do
    @compile_cmd
    |> :os.cmd
    |> String.Chars.to_string
  end

  def output_count(warnings) do
    IO.puts("Clean-up commensing for #{length(warnings)} warning(s)")
    warnings
  end
end
