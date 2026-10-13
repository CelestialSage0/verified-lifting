#include <bits/stdc++.h>

using namespace std;
namespace fs = std::filesystem;

static string shell_quote(const string &value)
{
    string quoted = "'";
    for (char c : value)
    {
        if (c == '\'')
        {
            quoted += "'\\''";
        }
        else
        {
            quoted += c;
        }
    }
    quoted += "'";
    return quoted;
}

int main(int argc, char *argv[])
{
    const fs::path root = fs::current_path();
    const fs::path script = root / "scripts/run-klee.sh";

    if (!fs::exists(script))
    {
        cerr << "Error: run this command from the UGRC root.\n";
        return 1;
    }

    const fs::path input = fs::absolute(argv[1]);

    if (!fs::exists(input) || !fs::is_regular_file(input))
    {
        cerr << "Error: input file does not exist: "
             << input << '\n';
        return 1;
    }

    if (input.extension() != ".cpp")
    {
        cerr << "Error: expected a .cpp source file.\n";
        return 1;
    }

    const fs::path relative_input = fs::relative(input, root);

    if (relative_input.empty() ||
        *relative_input.begin() == "..")
    {
        cerr << "Error: input must be inside the UGRC repository.\n";
        return 1;
    }

    const string test = input.stem().string();
    const fs::path relative_output =
        fs::path("artifacts") / test;

    fs::create_directories(root / relative_output);

    const string command =
        "bash " + shell_quote(script.string()) + " " +
        shell_quote(relative_input.generic_string()) + " " +
        shell_quote(relative_output.generic_string());

    cout << "Input:  " << relative_input << '\n'
         << "Output: " << relative_output << '\n';

    const int result = system(command.c_str());

    if (result != 0)
    {
        cerr << "Error: compilation or KLEE execution failed.\n";
        return 1;
    }

    cout << "Pipeline completed successfully.\n";
    return 0;
}