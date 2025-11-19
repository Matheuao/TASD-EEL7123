# Formulação do problema

O objetivo deste trabalho é desenvolver, em FPGA, uma unidade aritmética capaz de realizar a multiplicação de constantes no sistema Residue Number System (RNS), conforme apresentado nas aulas teóricas. Para isso, utilizam-se as bases previamente implementadas nos laboratórios Lab1_RNS e Lab2_RNS, responsáveis pela conversão entre representações binária e residual. A arquitetura projetada deve permitir a seleção, por meio de um sinal de controle SEL de 2 bits, entre quatro constantes pré-definidas: C1 = 34817, C2 = 26113, C3 = 21761 e C4 = 13057. O trabalho consiste na implementação dessa estrutura completa, integrando os módulos já fornecidos com os blocos adicionais designados ao aluno, seguida da sua emulação e validação em uma plataforma FPGA.

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

