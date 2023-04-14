# WumpusWorld
Kadir Ersoy

In our WumpusWorld, the agent always starts from grid (1,1) facing to east

Each grid (except (1,1)) might contain a Wumpus that

| (1,1) | (1,2) | (1,3) | … |
| --- | --- | --- | --- |
| (2,1) |  (2,2) |  (2,3) | … |
|  … | … | … | … |

Each grid (except (1,1)) might contain a Wumpus that

- creates small in its 4 neighbor grids.
- can be seen from a grid,
    - if that grid is in the same row or column (direct view for the agent)
    - if the distance between two grids is 4 or less depending on agent’s view…
        - E.g. if the Wumpus is at grid (1,4), it can be seen from:
            - (1,1), (1,2), (1,3) if the agent faces east
            - (1,5), (1,6), (1,7), (1,8) if the agent faces west
            - (2,4), (3,4), (4,4), (5,4) if the agent faces north
- The Wumpus becomes invisible after being seen.

At each time-step the agent can take the following actions:

- forward, counterClockWise, clockWise, hit

At each time-step, the agent might receive:

- wumpusSmell, wumpusSight, bump

`The agent wins the game if it kills a Wumpus by hit action when it is next to the Wumpus and facing it.`

`The agent learns the location of the walls after bumping. After learning the location, its wallInFront predicate should work correctly.`

Program can be evaluated by

- concatenating [rules.pl](http://rules.pl/) with some experience (examples below) in [kb.pl](http://kb.pl/)
- loading [kb.pl](http://kb.pl/) in swipl
- with isWinner() predicate

Example [kb.pl](http://kb.pl)

```prolog
wumpusSight(1).
action(1,clockWise).
action(2,forward).
action(3,counterClockWise).
action(4,counterClockWise).
action(5,forward).
action(6,clockWise).
action(7,forward).
action(8,forward).
wumpusSmell(9).
action(9,hit).

```

Here isWinner(9) should be True

```prolog
action(1,forward).
bump(2).
action(2,clockWise).
action(3,forward).
action(4,counterClockWise).
action(5,forward).
action(6,counterClockWise).
```

Here wallInFront(7) should be True.
