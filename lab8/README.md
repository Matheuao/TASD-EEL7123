# Formulação do problema

Este projeto de laboratório implementa, em lógica digital, um circuito que calcula Y = 36A + 44B + 164C + 548D + 36, onde A, B, C e D são entradas de 4 bits provenientes dos switches SW(3..0), SW(7..4), SW(11..8) e SW(15..12), e o resultado é mostrado em LEDR(12..0). Para isso foi construída a matriz de informação e projetado um compressor que a reduz a dois vetores parciais, os quais são então somados por um somador final. O projeto foi validado por simulação RTL (bancos de teste/testbenches) e em hardware real no FPGA, comprovando o correto comportamento lógico e físico. Foram avaliadas duas versões do algoritmo: a primeira emprega a técnica de compressão e soma; a segunda descreve explicitamente somadores e multiplicadores usando os operadores * e +. Ambas foram comparadas quanto à frequência máxima alcançável e à ocupação de recursos no FPGA.
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
