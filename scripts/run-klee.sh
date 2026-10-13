
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: run-klee.sh <source.c> <output-directory>" >&2
    exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$1"
OUTPUT="$2"
IMAGE="${KLEE_IMAGE:-klee/klee:latest}"

if [[ ! -f "$ROOT/$SOURCE" ]]; then
    echo "Error: source file not found: $ROOT/$SOURCE" >&2
    exit 1
fi

mkdir -p "$ROOT/$OUTPUT"

sudo docker run --rm \
    -v "$ROOT:$ROOT:Z" \
    -w "$ROOT" \
    "$IMAGE" \
    bash -lc '
        set -euo pipefail

        src="$1"
        out="$2"

        echo "=== Tool versions ==="
        klee --version

        compiler=""
        for candidate in clang-16 clang; do
            if command -v "$candidate" >/dev/null 2>&1; then
                compiler="$(command -v "$candidate")"
                break
            fi
        done

        if [[ -z "$compiler" ]]; then
            echo "Error: no Clang compiler found in the KLEE image." >&2
            exit 1
        fi

        echo "Compiler: $compiler"
        "$compiler" --version

        header="$(find /usr /opt /klee /tmp \
            -path "*/klee/klee.h" -print -quit 2>/dev/null || true)"

        if [[ -z "$header" ]]; then
            echo "Error: klee/klee.h not found in the container." >&2
            exit 1
        fi

        include_dir="${header%/klee/klee.h}"
        mkdir -p "$out"

        echo "=== Compiling C source to LLVM bitcode ==="
        "$compiler" \
            -emit-llvm -c -g -O0 \
            "$src" -o "$out/program.bc"

        echo "=== Running KLEE ==="
        klee \
            -write-smt2s \
            "$out/program.bc"

        echo "=== Generated artifacts ==="
        find "$out" -maxdepth 2 -type f -print
    ' _ "$SOURCE" "$OUTPUT"