% Kadir Ersoy, 2018400252
% Cmpe 480 hw2

'''
Load the rules.pl with a knowledege base(described in ReadMe)
Try iswinner(time) and wallInFront(time) functions
'''

dir(0, east).
dir(1, east).
%forward, counterClockWise, clockWise, hit
% action(T, act) is provided with experience.
dir(T1, north) :-
T0 is T1 - 1,
(
((action(T0,hit);action(T0,forward)), dir(T0,north) );
(action(T0,clockWise) , dir(T0,west));
(action(T0,counterClockWise), dir(T0,east))
).
dir(T1, east) :-
T0 is T1 - 1,
(
((action(T0,hit);action(T0,forward)), dir(T0,east) );
(action(T0,clockWise) , dir(T0,north));
(action(T0,counterClockWise), dir(T0,south))
).
dir(T1, west) :-
T0 is T1 - 1,
(
((action(T0,hit);action(T0,forward)), dir(T0,west) );
(action(T0,clockWise) , dir(T0,south));
(action(T0,counterClockWise), dir(T0,north))
).
dir(T1, south) :-
T0 is T1 - 1,
(
((action(T0,hit);action(T0,forward)), dir(T0,south) );
(action(T0,clockWise) , dir(T0,east));
(action(T0,counterClockWise), dir(T0,west))
).


locationX(0, 1, 1):- !.
locationX(1, 1, 1):- !.
locationX(T1,R,C) :-
T0 is T1 - 1,
(   
((action(T0,hit);action(T0,clockWise);action(T0,counterClockWise)), locationX(T0,Rpre,Cpre), (R is Rpre), (C is Cpre));
(action(T0,forward), bump(T1), locationX(T0,Rpre,Cpre),  (R is Rpre), (C is Cpre));
(action(T0,forward), dir(T0,north), not(bump(T1)), locationX(T0,Rpre,Cpre),  (R is Rpre-1), (C is Cpre));
(action(T0,forward), dir(T0,south), not(bump(T1)), locationX(T0,Rpre,Cpre),  (R is Rpre+1), (C is Cpre));
(action(T0,forward), dir(T0,west), not(bump(T1)), locationX(T0,Rpre,Cpre),  (R is Rpre), (C is Cpre-1));
(action(T0,forward), dir(T0,east), not(bump(T1)), locationX(T0,Rpre,Cpre),  (R is Rpre), (C is Cpre+1))
),!.
    
bump(0):- false.
wumpusSight(0):-false.
getNext4pos(R,C,east,List):- 
    C1 is C + 1,
    C2 is C + 2,
    C3 is C + 3,
    C4 is C + 4,
    List = [(R,C1),(R,C2),(R,C3),(R,C4)].
getNext4pos(R,C,west,List):- 
    C1 is C - 1,
    C2 is C - 2,
    C3 is C - 3,
    C4 is C - 4,
    List = [(R,C1),(R,C2),(R,C3),(R,C4)].
getNext4pos(R,C,north,List):- 
    R1 is R - 1,
    R2 is R - 2,
    R3 is R - 3,
    R4 is R - 4,
    List = [(R1,C),(R2,C),(R3,C),(R4,C)].
getNext4pos(R,C,south,List):- 
    R1 is R + 1,
    R2 is R + 2,
    R3 is R + 3,
    R4 is R + 4,
    List = [(R1,C),(R2,C),(R3,C),(R4,C)].
getNext4pos(T1,List):- 
    locationX(T1, R, C), dir(T1, Dir), getNext4pos(R, C, Dir, List).

wallInFront(T1):- 
    (   % if bump gives knowledge at the same tour, Tx =< T1, 
    	% if bump gives knowledge after the tour Tx < T1
    	( bump(Tx), Tx =< T1, getNextLoc(Tx, R, C), getNextLoc(T1,Rnext,Cnext), (Rnext == R), (Cnext == C) )
    ),!.

getNextLoc(T1, Rnext, Cnext):-
    locationX(T1, R, C),
    (   
    	( dir(T1, north), (Rnext is R - 1), (Cnext is C));
    	( dir(T1, south), (Rnext is R + 1), (Cnext is C));
    	( dir(T1, west), (Cnext is C - 1), (Rnext is R));
    	( dir(T1, east), (Cnext is C + 1), (Rnext is R))
    ), !.

hasBeenTo(0, _, _):- false,!.
hasBeenTo(T1, R, C):-
    locationX(T1, Rx, Cx),
    (   
    	( ( ( (R is Rx+1) ; (R is Rx-1)), (C is Cx)) ; (((C is Cx+1) ; (C is Cx-1)), ( R is Rx ) ) ),
    	(not(wumpusSmell(T1))) 
    );
    (T0 is T1-1, T0 > 0 ,hasBeenTo(T0, R,C), !).

isPossibleWumpus(T,R,C):-
    (   % check if hit location is in possible wumpus Locations
    	( wumpusSight(Tx), dir(Tx, east), locationX(Tx, Rx, Cx),(R == Rx) , (C =< Cx+4 ), (C >= Cx+1), ( Th is T-1, not(hasBeenTo(Th,R,C)) )  );
    	( wumpusSight(Tx), dir(Tx, west), locationX(Tx, Rx, Cx),(R == Rx) , (C >= Cx-4 ), (C =< Cx-1), ( Th is T-1, not(hasBeenTo(Th,R,C)) )  );
    	( wumpusSight(Tx), dir(Tx, south), locationX(Tx, Rx, Cx),(C == Cx) , (R =< Rx+4 ), (R >= Rx+1), ( Th is T-1, not(hasBeenTo(Th,R,C)) )  );
    	( wumpusSight(Tx), dir(Tx, north), locationX(Tx, Rx, Cx),(C == Cx) , (R >= Rx-4 ), (R =< Rx-1), ( Th is T-1, not(hasBeenTo(Th,R,C)) )  )
    ),!.

borderCheck(R,C):-
    (R>0, C>0).
trial(Thit,Dir):-
    not(dir(Thit, Dir)).
isWinner(T1) :- 
    % assuming action hit is the ending, if not
    % we must do wumpusDied check recursively
    %T0 is T1 - 1,
    %wumpusDied(T0),
    (   action(Thit, hit),    wumpusSmell(Thit), (Thit =< T1)),
    (   getNextLoc(Thit, Rhit, Chit), isPossibleWumpus(Thit, Rhit, Chit)),
    ( % check if any adjacent tile is also in possible wumpus locations, if so return false  
    	locationX(Thit, R, C),
        (   
    	( not(trial(Thit, north)); ( (RnextN is R-1), (CnextN is C), (  ( not( borderCheck(RnextN, CnextN)) ); not( isPossibleWumpus(Thit, RnextN, CnextN) ) ),! ) ),
    	( not(trial(Thit, south)); ( (RnextS is R+1), (CnextS is C), ( ( not(borderCheck(RnextS, CnextS)) ); not( isPossibleWumpus(Thit, RnextS, CnextS) ) ),! ) ),
    	( not(trial(Thit, west)); ( (RnextW is R), (CnextW is C-1), ( ( not(borderCheck(RnextW, CnextW)) ); not( isPossibleWumpus(Thit, RnextW, CnextW) ) ),! ) ),
    	( not(trial(Thit, east)); ( (RnextE is R), (CnextE is C+1), ( ( not(borderCheck(RnextE, CnextE)) ); not( isPossibleWumpus(Thit, RnextE, CnextE) ) ),! ) )
        ),!
    ),!.
