# Projeto: Mundo dos Blocos com Planejamento e Percepção

Este projeto foi desenvolvido com base no conceito de manipulação de blocos descrito no Capítulo 17, página 403, do livro de Ivan Bratko. O objetivo é simular um sistema de planejamento baseado em ações, utilizando lógica de Prolog para mover blocos entre diferentes estados enquanto satisfaz metas definidas. Este README detalha o funcionamento do código, as estruturas de dados utilizadas, as funcionalidades implementadas e como executá-lo.

## Descrição Geral

O projeto implementa um sistema de planejamento no "Mundo dos Blocos", no qual diferentes blocos estão posicionados em um grid, com posições livres ou ocupadas. O sistema permite:

- Planejar movimentos de blocos de uma configuração inicial para uma final.
- Executar ações que movem blocos, garantindo que as restrições (como posições livres e pré-condições) sejam respeitadas.
- Utilizar percepções para observar a posição de blocos antes de executar ações.
- Verificar se todas as metas foram alcançadas, regredir metas e planejar com base nas pré-condições de ações.

### Regras Básicas do Mundo dos Blocos

- **Estados**: Um estado é uma configuração que descreve onde cada bloco está localizado. Os blocos podem estar sobre o grid em posições únicas ou em pilhas que ocupam múltiplas posições.
- **Ações**: As ações consistem em mover blocos de uma posição para outra, respeitando as pré-condições, como se o bloco está livre para ser movido e se a nova posição está desocupada.
- **Metas**: As metas descrevem o estado final desejado, que pode incluir posições específicas para os blocos ou se um bloco está empilhado sobre outro.
  
## Estruturas Principais

1. **Estado Inicial**: Define onde cada bloco está no início da execução.
    ```prolog
    estado_inicial([
        bloco(c, [1, 2]),   % Bloco c nas posições 1 e 2
        bloco(a, 4),        % Bloco a na posição 4
        bloco(b, 6),        % Bloco b na posição 6
        bloco(d, [4, 6])    % Bloco d empilhado nas posições 4 e 6
    ]).
    ```

2. **Estado Final**: Define o objetivo final, onde cada bloco deve estar após a execução do plano.
    ```prolog
    estado_final([
        bloco(c, [1, 2]),   % Bloco c permanece nas posições 1-2
        bloco(a, 1),        % Bloco a deve estar sobre o bloco c
        bloco(d, [3, 5]),   % Bloco d deve estar nas posições 3-5
        bloco(b, 6)         % Bloco b permanece na posição 6
    ]).
    ```

3. **Predicados Principais**:
    - `satisfied/2`: Verifica se todas as metas foram alcançadas no estado atual.
    - `select_goal/2`: Seleciona uma meta da lista de metas para tentar alcançá-la.
    - `achieves/2`: Verifica se uma ação pode alcançar uma meta específica.
    - `preserves/2`: Verifica se uma ação preserva todas as metas sem violá-las.
    - `regress/3`: Regressa as metas após uma ação, levando em consideração pré-condições.
    - `can/2`: Verifica se uma ação pode ser executada baseado em suas pré-condições.
    - `move/5`: Move um bloco de uma posição para outra, atualizando o estado.
    - `look/3`: Percepção que permite "olhar" uma posição e identificar o objeto nela.

## Funcionamento do Código

O fluxo básico do sistema é o seguinte:

1. **Seleção de Metas**: O sistema primeiro verifica as metas que precisam ser alcançadas.
2. **Planejamento de Ações**: Para cada meta, o sistema seleciona uma ação que possa satisfazê-la, verificando as pré-condições necessárias. Se uma ação não puder ser executada, o sistema regressa as metas e recalcula os passos.
3. **Execução de Ações**: As ações são executadas em sequência, movendo blocos de uma posição para outra. Cada movimento atualiza o estado do mundo dos blocos.
4. **Verificação de Satisfação de Metas**: O sistema verifica se todas as metas foram alcançadas após a execução de cada ação.

### Exemplo de Execução

Dado o estado inicial:

```prolog
estado_inicial([
    bloco(c, [1, 2]),  
    bloco(a, 4),        
    bloco(b, 6),        
    bloco(d, [4, 6])    
]).
```

E o estado final desejado:

```prolog

estado_final([
    bloco(c, [1, 2]),   
    bloco(a, 1),        
    bloco(d, [3, 5]),   
    bloco(b, 6)         
]).

```
O sistema gera um plano que moverá os blocos de acordo com as metas definidas. Por exemplo, moverá o bloco a da posição 4 para a posição 1 (sobre o bloco c), e o bloco d para as posições 3-5.

Durante a execução, o sistema também usa percepções para verificar o estado atual, garantindo que as ações estejam corretas.
Predicados de Percepção e Heurística

Percepção: O predicado look/3 permite que o sistema "olhe" para uma posição e identifique qual objeto (bloco) está ali. Isso é importante para validar o estado antes de executar uma ação.

Exemplo:

```prolog

look([1, 2], Objeto, Estado).

```

Heurística: Para melhorar o planejamento, o sistema usa o predicado heuristica/2, que calcula um valor baseado no tamanho dos blocos e prioriza os blocos maiores para movimentos.

Exemplo:

```prolog

heuristica(Estado, Score).

```

## Como Executar

1. Acesse o [SWISH](https://swish.swi-prolog.org/), um ambiente online para Prolog.
2. Copie e cole o código Prolog no editor do SWISH.
3. Defina o estado inicial e o estado final.
4. Execute o plano chamando o predicado `plan/3`:

    ```prolog
    plan(estado_inicial, estado_final, Plano).
    ```

O sistema gerará e executará o plano de ações necessário para mover os blocos.


## Como Executar no SWI-Prolog

1. Instale o SWI-Prolog no seu computador, se ainda não tiver feito isso. Você pode baixar a versão mais recente no site oficial: SWI-Prolog Downloads.
2. Após a instalação, abra o terminal (Linux ou macOS) ou o prompt de comando (Windows).
3. Navegue até o diretório onde o seu arquivo .pl (arquivo Prolog) está salvo.
4. Inicie o SWI-Prolog com o comando:

```prolog
swipl
```

Carregue o seu arquivo Prolog utilizando o comando:

```prolog
?- [nome_do_arquivo].
```

Defina o estado inicial e o estado final e chame o predicado plan/3 para gerar o plano:

```prolog
    ?- plan(estado_inicial, estado_final, Plano).
```

O sistema calculará o plano de ações necessário para alcançar o estado final a partir do estado inicial.

## Conclusão

Este projeto demonstra como planejar e executar ações no mundo dos blocos, usando regras de lógica e planejamento automático. O uso de percepções e heurísticas torna o sistema mais eficiente e capaz de lidar com diferentes cenários e metas.

