defmodule Housekeeper.Cleaner do
  @moduledoc false

  def clean(warnings) do
    warnings
    |> Enum.group_by(fn ({_, file, _, _}) -> file end)
    |> Enum.each(&cleanup_file/1)
  end

  defp cleanup_file({file_path, corrections}) do
    updated_contents =
      file_path
      |> File.read!
      |> String.split("\n")
      |> Enum.with_index(1)
      |> Enum.map(&cleanup_line(&1, corrections))
      |> Enum.reject(&(&1 == nil)) # reject nil lines, we want to remove them
      |> Enum.join("\n")

    File.write!(file_path, updated_contents)
  end
  defp cleanup_file(_), do: nil # do nothing

  defp cleanup_line({line, index}, corrections) do
    index
    |> line_corrections(corrections)
    |> process_line(line)
  end

  defp line_corrections(index, corrections), do: Enum.find(corrections, fn ({_, _, lineno, _}) -> lineno == index end)

  defp process_line(nil, line), do: line
  defp process_line({:expansion, _, _, variable_name}, line), do: String.replace(line, variable_name, "#{variable_name}()")
  defp process_line({:import, _, _, _}, _), do: nil
  defp process_line({:variable, _, _, variable_name}, line) do
    case Regex.run(~r/(\s*)#{variable_name}\s*=(.*)$/, line, return: :index) do
      [_, _, {_, 0}] -> nil
      [_, {_, padding}, {start, len}] ->
        line |> String.slice(start, len) |> String.trim_leading |> String.pad_leading(len + padding - 1)
      _ -> String.replace(line, ~r/(?<!:)#{variable_name}(?!:)/, "_#{variable_name}", global: false)
    end
  end
end
