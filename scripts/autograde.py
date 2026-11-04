#!/usr/bin/env python3
"""Avaliador simples, independente do serviço GitHub Classroom.

Lê .github/classroom/autograding.json no formato utilizado em semestres
anteriores e executa seus testes de comando. Os testes são públicos e
fornecem feedback formativo; a nota final exige revisão do professor.
"""
from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
CONFIG = ROOT / ".github/classroom/autograding.json"


def evaluate_test(spec: dict) -> tuple[bool, str]:
    commands = [spec.get("setup", "").strip(), spec["run"]]
    outputs = []
    try:
        for command in commands:
            if not command:
                continue
            completed = subprocess.run(
                command,
                shell=True,
                executable="/bin/bash",
                cwd=ROOT,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=int(spec.get("timeout", 180)),
                check=False,
            )
            outputs.append(completed.stdout)
            if completed.returncode != 0:
                return False, "\n".join(outputs)
    except subprocess.TimeoutExpired as exc:
        return False, f"Tempo limite excedido ({spec.get('timeout')} s).\n{exc.stdout or ''}"
    output = "\n".join(outputs)
    comparison = spec.get("comparison", "included")
    expected = spec.get("output", "")
    if comparison == "included":
        return expected in output, output
    if comparison == "exact":
        return expected.strip() == output.strip(), output
    return False, f"Comparação não suportada: {comparison}"


def main() -> int:
    data = json.loads(CONFIG.read_text(encoding="utf-8"))
    points_total = sum(int(t["points"]) for t in data["tests"])
    awarded = 0
    report = ["## Resultado dos testes Hspec", "", "| Teste | Resultado | Pontos |", "|---|---|---:|"]
    failed = False

    for spec in data["tests"]:
        ok, out = evaluate_test(spec)
        pts = int(spec["points"]) if ok else 0
        awarded += pts
        failed |= not ok
        result = "PASS" if ok else "FAIL"
        name = spec["name"].replace("|", r"\|")
        print(f"\n[{result}] {name}: {pts}/{spec['points']} pontos", flush=True)
        if not ok:
            print(out[-12000:], flush=True)
        report.append(f"| {name} | {result} | {pts}/{spec['points']} |")

    report += ["", f"**Pontuação obtida: {awarded}/{points_total}.**",
               "", "Pontuação formativa; a avaliação oficial poderá considerar"
               " critérios adicionais e penalização por atraso."]
    summary = "\n".join(report) + "\n"
    print(summary)
    if os.getenv("GITHUB_STEP_SUMMARY"):
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a", encoding="utf-8") as f:
            f.write(summary)
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
