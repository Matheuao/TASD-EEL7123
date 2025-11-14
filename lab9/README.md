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

