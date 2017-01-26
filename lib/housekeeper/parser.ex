defmodule Housekeeper.Parser do
  @moduledoc false

  @expansion ~r/warning: variable "([^\s]*)" does not exist and is being expanded.*\n\s+([\w_\/.]+):(\d+)/i
  @unused_import ~r/warning: unused import ([^\s]*)\n\s+([\w_\/.]+):(\d+)/i
  @unused_variable ~r/warning: variable ([^\s]*) is unused\n\s+([\w_\/.]+):(\d+)/i

  @doc """
  Parse the compiler output for warnings
  """
  def parse(output) do
    output
    |> unused_variables
    |> unused_imports
    |> variable_expansion
  end

  defp unused_variables(output) do
    warnings = scan_warnings(output, @unused_variable, :variable)
    IO.puts "Found #{length(warnings)} unused variables"

    {output, warnings}
  end

  defp unused_imports({output, acc}) do
    warnings = scan_warnings(output, @unused_import, :import)
    IO.puts "Found #{length(warnings)} unused imports"

    {output, acc ++ warnings}
  end

  defp variable_expansion({output, acc}) do
    warnings = scan_warnings(output, @expansion, :expansion)
    IO.puts "Found #{length(warnings)} expansion warnings"

    acc ++ warnings
  end

  defp scan_warnings(output, pattern, type) do
    pattern
    |> Regex.scan(output)
    |> Enum.map(fn ([_, name, file, lineno]) -> {type, file, String.to_integer(lineno), String.replace(name, "\"", "")} end)
  end
end
