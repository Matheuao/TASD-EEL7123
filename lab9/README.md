# Formulação do problema

O experimento consiste em projetar e emular, na placa DE2, um sistema completo datapath-controle capaz de realizar exponenciação modular de 16 bits. O trabalho inclui o desenvolvimento de um registrador Multimodo parametrizável, integrando multiplexadores, registradores com reset/enable e lógica aritmética dedicada. Também envolve o projeto formal de uma FSM de controle, responsável por coordenar as fases de cálculo da operação $A^C$. Por fim, o sistema é implementado e validado em hardware real.

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

# Resultados de Síntese: Comparação entre as duas Implementações

Foram avaliadas duas versões do circuito:  
1. **Compressão e Soma** – implementação estrutural que exige a construção da matriz de informação, redução por compressores e soma final. Essa abordagem demanda maior esforço de engenharia.  
2. **Baseline** – implementação direta da expressão utilizando os operadores `*` e `+`, sem otimizações manuais.

A tabela abaixo apresenta os resultados de síntese no FPGA:

| Implementação       | FMAX          | Elementos Lógicos Utilizados |
|---------------------|---------------|------------------------------|
| Compressão e Soma   | 207.86 MHz    | 85 / 114,480 (< 1%)          |
| Baseline            | 179.76 MHz    | 76 / 114,480 (< 1%)          |

Os resultados mostram que a técnica de compressão e soma alcançou uma frequência máxima maior, ao custo de um pequeno aumento no número de elementos lógicos utilizados, quando comparada à versão baseline.
