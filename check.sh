
#!/bin/bash

all_pass=0

for i in {1..4}
do
    input_dir="Testcase${i}"
    output_dir="Testcase${i}Diff"

    passed=1
    has_diff=0

    for file1 in "$input_dir"/*.1.txt
    do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        name=$(basename "$file1" .1.txt)
        output_file="$output_dir/${name}Diff.txt"

        if ! cmp -s "$file1" "$file2"; then
            has_diff=1

            if [ ! -f "$output_file" ]; then
                passed=0
            else
                if ! diff -u "$file1" "$file2" | tail -n +3 | cmp -s - <(tail -n +3 "$output_file"); then
                    passed=0
                fi
            fi
        else
            if [ -f "$output_file" ]; then
                passed=0
            fi
        fi
    done

    if [ "$has_diff" -eq 1 ]; then
        if [ ! -d "$output_dir" ]; then
            passed=0
        fi
    else
        if [ -d "$output_dir" ]; then
            passed=0
        fi
    fi

    if [ "$passed" -eq 1 ]; then
        echo "Testcase${i}: PASS"
    else
        echo "Testcase${i}: FAIL"
        all_pass=1
    fi
done

exit "$all_pass"

