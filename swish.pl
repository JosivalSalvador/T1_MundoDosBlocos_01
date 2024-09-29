% Definindo o movimento de blocos
mover(Bloco, De, Para) :-
    limpar(Bloco),
    limpar(Para),
    assert(em(Bloco, Para)),
    retract(em(Bloco, De)).

% Definindo pré-condições para estabilidade
limpar(Bloco) :-
    not(em(OutroBloco, Bloco)).

% Adição de variáveis não instanciadas no planejamento
planner(State, Goal) :-
    can(Act, State, [Goal | RestGoals]),
    execute(Act, State, NewState),
    planner(NewState, RestGoals).

% Verifica as pré-condições com variáveis
can(mover(Bloco, De, Para), State, [limpar(Bloco), limpar(Para)]) :-
    holds(limpar(Bloco), State),
    holds(limpar(Para), State).

% Fatos iniciais (exemplo de teste)
em(a, posicao1).
em(b, posicao2).
