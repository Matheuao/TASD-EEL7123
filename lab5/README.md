# Formulação do Problema

O objetivo deste laboratório é implementar uma unidade aritmética baseada no problema resolvido pelo aluno no Capítulo 5.
A unidade deve realizar as seguintes operações:

* Quando o sinal de controle `c = 0`:
  **R = 85 × A**

* Quando o sinal de controle `c = 1`:
  **R = 49 × A + 1164**

onde `A` é uma entrada sem sinal de 4 bits, e `R` é uma saída sem sinal de 11 bits.

A implementação deve ser feita em **VHDL**, utilizando o somador de 8 bits e a menor quantidade possível de lógica adicional.
O limite máximo de componentes adicionais permitidos é:

* 3 portas MUX 2:1
* 3 portas OR de duas entradas
* 2 portas AND de duas entradas
* 2 portas NOT

---

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

