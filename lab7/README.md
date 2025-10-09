# Formulação do problema

Este repositório contém a implementação em FPGA de uma unidade conversora entre o sistema de numeração residual (RNS) e o sistema binário, baseada nas aulas teóricas; o objetivo é fornecer blocos reutilizáveis para as próximas aulas experimentais, onde serão construídas unidades RNS completas com funcionalidades aritméticas de soma e multiplicação. O projeto adota o conjunto de módulos {m1, m2, m3} = {2^{2n}, 2^{n}-1, 2^{n}+1} e consiste em um conversor RNS→binário (Lab2_RNS). Inclui código, testbenches e instruções para síntese em FPGA, facilitando a integração e reutilização dos módulos nas atividades práticas seguintes.

# Como executar a simulação

## Dependências

* [GHDL](https://ghdl.github.io/ghdl/)
* [GTKWave](http://gtkwave.sourceforge.net/)

Certifique-se de que ambos estão instalados e acessíveis no seu terminal.

## Execução

Navegue até o diretório `vhdl` e execute o script de simulação:

```bash
cd vhdl
bash run.sh
```