% Predicado que verifica se todas as metas foram satisfeitas
satisfied(State, Goals) :-
    subset(Goals, State),
    !, % Evita backtracking desnecessário
    write('Goals satisfied'), nl.

% Seleciona uma meta da lista de metas
select_goal([Goal|_], Goal) :-
    write('Selected goal: '), write(Goal), nl.

% Verifica se a ação alcança a meta, manipulando variáveis não instanciadas
achieves(Action, Goal) :-
    adds(Action, Effects),
    member(Goal, Effects),
    !, % Evita backtracking desnecessário
    write('Action '), write(Action), write(' achieves goal '), write(Goal), nl.

% Verifica se a ação preserva todas as metas, sem violar as pré-condições
preserves(Action, Goals) :-
    deletes(Action, DeletedEffects),
    \+ (member(Goal, DeletedEffects),
        member(Goal, Goals)),
    !, % Evita backtracking se uma condição falha
    write('Action '), write(Action), write(' preserves all goals'), nl.

% Regressa as metas após uma ação, lidando com variáveis não instanciadas
regress(Goals, Action, RegressedGoals) :-
    adds(Action, Effects),
    delete_all(Goals, Effects, RemainingGoals),
    can(Action, Preconditions),  % Verifica pré-condições da ação
    addnew(Preconditions, RemainingGoals, RegressedGoals),
    write('Regressed goals: '), write(RegressedGoals), nl.

% Remove metas já satisfeitas
remove_satisfied([], []).
remove_satisfied([Goal | Rest], CleanGoals) :-
    satisfied_goal(Goal),
    !,
    remove_satisfied(Rest, CleanGoals).
remove_satisfied([Goal | Rest], [Goal | CleanRest]) :-
    remove_satisfied(Rest, CleanRest).

% Predicado para verificar se uma meta já está satisfeita
satisfied_goal(livre(Bloco)) :- estado_inicial(Estado), livre(Bloco, Estado).
satisfied_goal(livre_destino(Posicao)) :- estado_inicial(Estado), livre_destino(Posicao, Estado).

% Verifica se uma ação pode ser realizada, usando pré-condições
can(Action, Preconditions) :-
    preconditions(Action, Preconditions),
    % Verificar se as precondições são satisfeitas antes de continuar
    forall(member(Precondition, Preconditions), satisfied_goal(Precondition)),
    write('Action '), write(Action), write(' can be done with preconditions '), write(Preconditions), nl.

% Predicado 'adds' que define os efeitos das ações
adds(move(Bloco, _, Para), [bloco(Bloco, Para)]).

% Predicado 'deletes' que define os efeitos deletados de uma ação
deletes(move(Bloco, De, _), [bloco(Bloco, De)]).

% Remove todos os itens de Goals que estão em Effects
delete_all([], _, []).
delete_all([G|Goals], Effects, Result) :-
    member(G, Effects),
    delete_all(Goals, Effects, Result).
delete_all([G|Goals], Effects, [G|Result]) :-
    delete_all(Goals, Effects, Result).

% Adiciona novas metas ao plano
addnew([], L, L).
addnew([Goal | _], Goals, _) :-
    impossible(Goal, Goals),
    write('Impossible goal: '), write(Goal), nl,
    !, fail.
addnew([X | L1], L2, L3) :-
    member(X, L2),
    !, addnew(L1, L2, L3).
addnew([X | L1], L2, [X | L3]) :-
    addnew(L1, L2, L3).

% Predicado auxiliar para verificar impossibilidades
impossible(_, _) :- false.


% Predicado 'preconditions' que define as pré-condições para as ações
preconditions(move(Bloco, _, Para), [livre(Bloco), livre_destino(Para)]).

% Verifica se o bloco está livre (não há nada em cima dele)
livre(Bloco, Estado) :-
    \+ (member(bloco(_, _, Bloco), Estado)),
    write('Block '), write(Bloco), write(' is free'), nl, !.

% Verifica se o destino está livre (não há outro bloco ocupando a posição)
livre_destino(Posicao, Estado) :-
    \+ member(bloco(_, Posicao), Estado),
    write('Position '), write(Posicao), write(' is free'), nl, !.


% Estado inicial do Mundo dos Blocos
estado_inicial([
    bloco(c, [1, 2]),   % Bloco azul (c) nas posições 1-2
    bloco(a, 4),        % Bloco roxo (a) na posição 4
    bloco(b, 6),        % Bloco amarelo (b) na posição 6
    bloco(d, [4, 6])    % Bloco vermelho (d) empilhado nas posições 4-6
]).

% Estado final desejado
estado_final([
    bloco(c, [1, 2]),   % Bloco azul (c) nas posições 1-2
    bloco(a, 1),        % Bloco roxo (a) sobre o bloco c
    bloco(d, [3, 5]),   % Bloco vermelho (d) nas posições 3-5
    bloco(b, 6)         % Bloco amarelo (b) na posição 6
]).

% Movimento dos blocos, respeitando restrições de estabilidade
move(Bloco, De, Para, Estado, NovoEstado) :-
    livre(Bloco, Estado),
    livre_destino(Para, Estado),
    \+ member(bloco(Bloco, Para), Estado),
    retira_bloco(Bloco, De, Estado, TempEstado),
    coloca_bloco(Bloco, Para, TempEstado, NovoEstado),
    write('Moved block '), write(Bloco), write(' from '), write(De), write(' to '), write(Para), nl.



% Atualização do estado ao remover um bloco de sua posição
retira_bloco(Bloco, Posicao, [bloco(Bloco, Posicao) | Resto], Resto) :-
    write('Retirando bloco '), write(Bloco), write(' da posição '), write(Posicao), nl.
retira_bloco(Bloco, Posicao, [OutroBloco | Resto], [OutroBloco | NovoResto]) :-
    retira_bloco(Bloco, Posicao, Resto, NovoResto).

% Coloca um bloco em uma nova posição e atualiza o estado
coloca_bloco(Bloco, Posicao, Estado, [bloco(Bloco, Posicao) | Estado]) :-
    write('Colocando bloco '), write(Bloco), write(' na posição '), write(Posicao), nl.

% Heurística para priorizar blocos maiores
heuristica(Estado, Score) :-
    findall(Tamanho, (member(bloco(_, Tamanho), Estado), Tamanho > 1), Tamanhos),
    sumlist(Tamanhos, Score),
    write('Heurística calculada: '), write(Score), nl.

% Ação de percepção: olha para uma posição e identifica o bloco
look(Posicao, Objeto, Estado) :-
    member(bloco(Objeto, Posicao), Estado),
    write('Looking at position '), write(Posicao), write(' and finding object '), write(Objeto), nl.

% Gera um plano de ações para mover os blocos do estado inicial para o final
plan(EstadoInicial, EstadoFinal, Plano) :-
    regress(EstadoFinal, _, Plano),
    executar_plano(Plano, EstadoInicial, EstadoFinal),
    write('Planning complete'), nl.

% Executa o plano gerado
executar_plano([], Estado, Estado) :-
    write('Plan execution complete'), nl.
executar_plano([move(Bloco, De, Para) | Restante], EstadoAtual, EstadoFinal) :-
    move(Bloco, De, Para, EstadoAtual, NovoEstado),
    executar_plano(Restante, NovoEstado, EstadoFinal).
