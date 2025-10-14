# Formulação do problema

Este repositório contém a implementação em FPGA de uma unidade conversora de binário para o sistema de numeração residual (RNS), conforme estudado nas aulas teóricas. O objetivo é fornecer um bloco reutilizável para as próximas aulas experimentais, nas quais serão desenvolvidas unidades RNS completas com funcionalidades aritméticas de soma e multiplicação. O projeto utiliza o conjunto de módulos {m1, m2, m3} = {2^{2n}, 2^{n}-1, 2^{n}+1} e corresponde ao conversor Binário→RNS (Lab1_RNS). Inclui código, testbenches e instruções para síntese em FPGA, facilitando a integração e evolução das unidades nas etapas seguintes.

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