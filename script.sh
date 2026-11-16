#!/bin/bash

for i in {1..4}
do
    input_dir="Testcase${i}"
    output_dir="Testcase${i}Diff"

    rm -rf "$output_dir"

    for file1 in "$input_dir"/*.1.txt
    do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        name=$(basename "$file1" .1.txt)

        if ! diff -q "$file1" "$file2" > /dev/null; then
            mkdir -p "$output_dir"
            diff -u "$file1" "$file2" > "$output_dir/${name}Diff.txt"
        fi
    done
done
