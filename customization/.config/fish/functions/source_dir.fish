function source_dir
    argparse 'h/help' 'd/dir=' 'r/recurse' -- $argv

    if set -q "$_flag_help"
        echo "Usage: source_dir -d [Path To Directory] (-r)"
        echo "-d, --dir"
        echo "      Directory path to use (sources all files in dir)"
        echo "-r, --recurse"
        echo "      If it should go through all dirs in --dir as well"
    end

    if test -d "$_flag_dir"
        for file in $_flag_dir/*
            if test -f "$file"
                source "$file"
                continue
            end

            if set -q "$_flag_recurse"; and test -d "$file"
                source_dir "$file" "$_flag_recurse"
            end
        end
    end
end
