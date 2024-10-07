% Definição de blocos e seus tamanhos
bloco(a, pequeno).
bloco(b, medio).
bloco(c, grande).
bloco(d, grande).

% Definindo a relação de tamanhos para garantir a estabilidade
maior(grande, medio).
maior(medio, pequeno).

% Definição de posições disponíveis
posicao(1).
posicao(2).
posicao(3).
posicao(4).
posicao(5).
posicao(6).

% Verifica se o bloco está suportado corretamente (na base ou em dois blocos)
suportado(X, Estado) :- 
    member(em(X, [P1, P2]), Estado), posicao(P1), posicao(P2), P1 =< 2.  % Se está na base, posições 1-2

suportado(X, Estado) :- 
    member(em(X, [P1, P2]), Estado), 
    member(em(Y, [PY1, PY2]), Estado), 
    posicao(P1), posicao(P2), posicao(PY1), posicao(PY2), % Verifica posições válidas
    bloco(X, TamanhoX), bloco(Y, TamanhoY), maior(TamanhoY, TamanhoX), 
    PY1 = P1, PY2 = P2, % As posições dos blocos suportam o bloco X
    suportado(Y, Estado).  % Suporte recursivo

% Verifica se a posição está livre no estado atual
livre(P1, P2, Estado) :- \+ member(em(_, [P1, P2]), Estado).

% Movimento de um bloco no estado atual (de uma posição dupla)
pode_mover(Bloco, DeP1, DeP2, ParaP1, ParaP2, Estado) :-
    bloco(Bloco, _),               % O objeto é um bloco válido
    posicao(DeP1), posicao(DeP2), posicao(ParaP1), posicao(ParaP2),    % As posições são válidas
    member(em(Bloco, [DeP1, DeP2]), Estado), % O bloco está na posição de origem
    livre(ParaP1, ParaP2, Estado),           % As posições de destino estão livres
    suportado(Bloco, Estado),      % O bloco está suportado corretamente antes de mover
    DeP1 \= ParaP1, DeP2 \= ParaP2.  % O destino é diferente da origem

% Movimento de um bloco: gera um novo estado após mover
move(Bloco, DeP1, DeP2, ParaP1, ParaP2, EstadoAtual, NovoEstado) :-
    pode_mover(Bloco, DeP1, DeP2, ParaP1, ParaP2, EstadoAtual),
    atualiza_estado(Bloco, [DeP1, DeP2], [ParaP1, ParaP2], EstadoAtual, NovoEstado),
    write(Bloco), write(' movido de '), write(DeP1), write('-'), write(DeP2), 
    write(' para '), write(ParaP1), write('-'), write(ParaP2), nl.

% Atualiza o estado sem usar predicados dinâmicos
atualiza_estado(Bloco, [DeP1, DeP2], [ParaP1, ParaP2], EstadoAtual, NovoEstado) :-
    remove(em(Bloco, [DeP1, DeP2]), EstadoAtual, EstadoIntermediario), % Remove a posição antiga
    adicionar(em(Bloco, [ParaP1, ParaP2]), EstadoIntermediario, NovoEstado).  % Adiciona nova posição

% Remover elemento de uma lista
remove(_, [], []).
remove(X, [X|T], T).
remove(X, [H|T], [H|R]) :- remove(X, T, R).

% Adicionar elemento a uma lista
adicionar(X, L, [X|L]).

% Predicado que exibe o estado atual do mundo dos blocos
estado(Estado) :-
    write('Estado atual dos blocos: '), nl,
    write(Estado), nl.

% Ação de percepção por câmera/sensor
look(Posicao, Estado) :-
    member(em(Objeto, Posicao), Estado),
    write('Na posição '), write(Posicao), write(' há o objeto: '), write(Objeto), nl.

% Verifica se uma posição está livre e informa
posicao_livre([P1, P2], Estado) :-
    livre(P1, P2, Estado),
    write('As posições '), write(P1), write('-'), write(P2), write(' estão livres.'), nl.

% Implementação da heurística especializada: distância do bloco até a meta
heuristica(Bloco, [MetaP1, MetaP2], Estado, Custo) :-
    member(em(Bloco, [P1, P2]), Estado),
    Custo is abs(P1 - MetaP1) + abs(P2 - MetaP2).

% Planejamento: encontra uma sequência de ações para transformar um estado inicial em um final
planejar(EstadoInicial, EstadoFinal, [mover(Bloco, DeP1, DeP2, ParaP1, ParaP2)|Plano], EstadoIntermediario) :-
    member(em(Bloco, [DeP1, DeP2]), EstadoInicial),
    member(em(Bloco, [ParaP1, ParaP2]), EstadoFinal),
    move(Bloco, DeP1, DeP2, ParaP1, ParaP2, EstadoInicial, EstadoNovo),
    planejar(EstadoNovo, EstadoFinal, Plano, EstadoIntermediario).

% Caso base: o planejamento termina quando o estado final é atingido
planejar(EstadoFinal, EstadoFinal, [], EstadoFinal).

% Função principal para iniciar o planejamento
resolver :-
    EstadoInicial = [em(c, [1, 2]), em(a, [4]), em(b, [6]), em(d, [4, 6])],  % Estado inicial correto
    EstadoFinal = [em(c, [1, 2]), em(a, [1]), em(b, [6]), em(d, [3, 5])],   % Estado final desejado
    estado(EstadoInicial),
    planejar(EstadoInicial, EstadoFinal, Plano, EstadoFinalNovo),
    write('Plano gerado: '), write(Plano), nl,
    estado(EstadoFinalNovo).
