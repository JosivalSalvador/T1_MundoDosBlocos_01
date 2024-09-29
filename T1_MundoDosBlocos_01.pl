% Definição de blocos e seus tamanhos
bloco(a, pequeno).
bloco(b, medio).
bloco(c, grande).

% Definição de posições disponíveis
posicao(1).
posicao(2).
posicao(3).
posicao(4).

% Estado inicial: blocos em suas posições
em(a, 1).
em(b, 2).
em(c, 3).

% Blocos suportados: um bloco só pode ser suportado se estiver em uma posição ou em um bloco maior
suportado(X) :- em(X, P), posicao(P).  % Se está diretamente no chão
suportado(X) :- em(X, Y), bloco(Y, TamanhoY), bloco(X, TamanhoX), maior(TamanhoY, TamanhoX), suportado(Y). % Se está em um bloco maior

% Definindo a relação de tamanhos para garantir a estabilidade
maior(grande, medio).
maior(medio, pequeno).

% Verifica se a posição está livre
livre(P) :- \+ em(_, P).

% Movimento simples de um bloco para uma posição livre e estável
pode_mover(Bloco, De, Para) :-
    bloco(Bloco, _),
    posicao(De), posicao(Para),
    em(Bloco, De),
    livre(Para),
    suportado(Bloco),  % Verifica se o bloco está estável antes de mover
    De \= Para.

% Movimento de um bloco
move(Bloco, De, Para) :-
    pode_mover(Bloco, De, Para),
    retract(em(Bloco, De)),
    assert(em(Bloco, Para)),
    write(Bloco), write(' movido de '), write(De), write(' para '), write(Para), nl.

% Predicado que exibe o estado atual do mundo dos blocos
estado :-
    findall((Bloco, Posicao), em(Bloco, Posicao), Blocos),
    write('Estado atual dos blocos: '), nl,
    write(Blocos), nl.

% Ação de percepção por câmera/sensor
look(Posicao, Objeto) :-
    em(Objeto, Posicao),
    write('Na posição '), write(Posicao), write(' há o objeto: '), write(Objeto), nl.

% Verifica se uma posição está livre
posicao_livre(Posicao) :-
    livre(Posicao),
    write('A posição '), write(Posicao), write(' está livre.'), nl.

% Implementação da heurística especializada: distancia do bloco até a meta
heuristica(Bloco, Meta, Custo) :-
    em(Bloco, P),
    Custo is abs(P - Meta).

% Planejamento com variáveis
planejar(Estado_inicial, Estado_final, [A|Plano]) :-
    estado_atual(Estado_inicial),
    transicao(Estado_inicial, A, Estado_intermediario),
    planejar(Estado_intermediario, Estado_final, Plano).

% Transição de estados, descreve como ações transformam o estado
transicao(Estado_inicial, mover(Bloco, De, Para), Estado_final) :-
    pode_mover(Bloco, De, Para),
    retract(em(Bloco, De)),
    assert(em(Bloco, Para)),
    Estado_final = em(Bloco, Para).

% Planejador que usa a heurística para mover blocos para as metas de forma eficiente
planejar_com_heuristica(Estado_inicial, Estado_final, Plano) :-
    estado_atual(Estado_inicial),
    heuristica(Estado_inicial, Estado_final, Custo),
    write('Custo estimado: '), write(Custo), nl,
    planejar(Estado_inicial, Estado_final, Plano).

% Função principal para iniciar o planejamento
resolver :-
    estado,
    planejar(em(a, 1), em(b, 3), Plano),
    write('Plano gerado: '), write(Plano), nl,
    executar_plano(Plano).

% Função para executar o plano gerado
executar_plano([]).
executar_plano([mover(Bloco, De, Para)|Resto]) :-
    move(Bloco, De, Para),
    executar_plano(Resto).
