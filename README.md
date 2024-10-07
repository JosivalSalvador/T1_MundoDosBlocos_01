SWISH Prolog:

# Planejador para o Mundo dos Blocos

Este projeto implementa um **planejador** para o mundo dos blocos em Prolog, que realiza a regressão de metas para gerar planos de movimento entre diferentes estados de blocos dispostos em uma grade 5x5. O planejador garante que os blocos sejam movidos de maneira estável, evitando que sejam colocados em posições instáveis.

## Estrutura do Código

O código foi projetado para trabalhar com um conjunto de predicados principais que permitem:
1. Verificar se as metas foram atingidas (`satisfied/2`).
2. Regressar metas após uma ação ser executada (`regress/3`).
3. Gerar o plano para mover blocos entre diferentes estados (`plan/3`).
4. Executar as ações geradas no plano para mover blocos no mundo.

### Predicados Principais:

- **`gerar_todos_planos/0`**: Gera os planos necessários para mover os blocos entre os estados iniciais e finais, passando por estados intermediários.
- **`plan/3`**: Este predicado é responsável por criar um plano de ações que leva do estado inicial ao estado final, seguindo um processo de regressão de metas.
- **`executar_plano/1`**: Executa cada ação do plano gerado e realiza as transições de estado.
- **`can/2`**: Verifica as condições necessárias para que uma ação seja possível.
- **`achieves/2`**: Determina se uma ação atinge uma determinada meta.

### Funções Auxiliares:

- **`conc/3`**: Junta dois planos.
- **`delete_all/3`**: Remove metas que já foram atingidas.
- **`addnew/3`**: Adiciona novas metas ao conjunto de metas.
- **`preserves/2`**: Garante que a ação não destrua as metas que ainda precisam ser satisfeitas.

## Como executar no SWISH Prolog

1. Acesse o site do [SWISH Prolog](https://swish.swi-prolog.org/).
2. Cole o código do arquivo no editor de código disponível no site.
3. Após colar o código, execute o predicado **`gerar_todos_planos/0`** para gerar e executar os planos de transição de blocos entre os estados. Digite o comando abaixo na linha de consulta:

    ```prolog
    ?- gerar_todos_planos.
    ```

4. O resultado exibirá os planos gerados, seguidos da execução das ações para mover os blocos no mundo definido.

### Exemplo de Execução:

Ao executar o predicado `gerar_todos_planos`, o sistema gerará os planos entre os estados intermediários e exibirá o seguinte tipo de saída:

Plano gerado de i1 para i2: [mover(a,4,3), mover(b,6,5)] Movendo o bloco a da posição 4 para a posição 3 Movendo o bloco b da posição 6 para a posição 5 ...

### Estrutura dos Estados:

Os blocos são organizados no grid com posições e estados como:

- **Estado Inicial (`estado_inicial/1`)**: Define as posições iniciais dos blocos.
- **Estado Final (`estado_final/1`)**: Define a meta final que o sistema deseja alcançar.
- **Estados Intermediários**: Posições intermediárias dos blocos durante as transições.

#### Exemplo de Estado Inicial:

```prolog
estado_inicial([em(c, 1), em(c, 2), em(a, 4), em(b, 6), em(d, 4), em(d, 5), em(d, 6), livre(3)]).
Exemplo de Estado Final:
estado_final([em(c, 1), em(c, 2), em(a, 3), em(d, 4), em(d, 5), em(b, 6), livre(7)]).
Transições:
i1 para i2: Transição do estado inicial para um estado intermediário.
i2 para variações (a, b, c): Transições entre estados intermediários variáveis (definidos como estado_intermediario_a, estado_intermediario_b, etc.).
Cada transição é implementada com planos específicos, como:
?- s_inicial_i1_para_i2.
?- s_inicial_i2_para_i2_a.
?- s_inicial_i2_para_i2_b.
?- s_inicial_i2_para_i2_c.
Esses predicados geram os planos e executam as ações correspondentes para mover os blocos entre os estados.

Conclusão
Este planejador automatizado em Prolog segue o modelo de regressão de metas e garante que blocos sejam movidos de maneira estável e eficiente no mundo dos blocos. Ele é ideal para entender como um sistema pode gerar e executar planos em ambientes estruturados, como um grid de posições numeradas.

### Foco do `README.md`:
- Instruções **simples e diretas** para uso no **SWISH Prolog**.
- **Descrição detalhada** das funcionalidades e do código.
- Instruções para **gerar e executar planos**.
- **Exemplo de execução** e transições de estados.