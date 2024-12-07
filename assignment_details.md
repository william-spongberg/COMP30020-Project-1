# Project Objective

The objective of this project is to practice and assess your understanding of logic programming and Prolog. You will write code to perform the major parts of a cribbage playing program.

## Cribbage Overview

Cribbage is a very old card game, dating to early 17th century England. There are 2, 3, and 4 handed versions of the game. The object of the game is to be the first player to reach 121 points. 

### Game Setup

- **2-player game**: Each player is dealt 6 cards.
- **3 or 4-player game**: Each player is dealt 5 cards. In a 3-player game, the dealer also deals one card to a separate hand called the crib or box.

Each player then chooses 1 or 2 cards to discard, keeping 4 and putting the discarded cards in the crib or box, which forms a second 4-card hand for the dealer. Next, the player preceding the dealer cuts the deck to select an extra card, called the start card. If the start card is a Jack, the dealer immediately scores 2 points.

### Game Phases

1. **Play**: Players take turns playing cards from their hands face up in front of them. (Not part of this project)
2. **Show**: Each player, beginning with the player after the dealer, establishes the value of their hand. The start card is considered part of each player's hand, making it a 5-card hand.

### Scoring Rules

- **15s**: 2 points for each distinct combination of cards that add to 15.
- **Pairs**: 2 points for each pair. 3 of a kind scores 6 points, and 4 of a kind scores 12 points.
- **Runs**: 1 point for each card in a run of 3 or more consecutive cards.
- **Flushes**: 4 points if all cards in the hand are of the same suit. 1 additional point if the start card is also the same suit.
- **"One for his nob"**: 1 point if the hand contains the Jack of the same suit as the start card.

### Example Hands

| Hand              | Start card | Points |
|-------------------|------------|--------|
| 7♣, Q♥, 2♣, J♣    | 9♥         | 0      |
| A♠, 3♥, K♥, 7♥    | K♠         | 2      |
| A♠, 3♥, K♥, 7♥    | 2♦         | 5      |
| 6♣, 7♣, 8♣, 9♣    | 8♠         | 20     |
| 7♥, 9♠, 8♣, 7♣    | 8♥         | 24     |
| 5♥, 5♠, 5♣, J♦    | 5♦         | 29     |

Following the show of each player's hand, the dealer counts the crib as a second hand, claiming any points therein. The player following the dealer then collects the cards and becomes the dealer for the next hand. Play proceeds this way until one player reaches 121 points.

Please see the rules of cribbage for a more complete description of the game. However, what is presented above will be enough to complete the project.

## Predicates to Implement

### `hand_value/3`

```prolog
hand_value(Hand, Startcard, Value)
```

- **Hand**: List of 4 card terms.
- **Startcard**: Single card term.
- **Value**: Total cribbage point value of Hand when Startcard is the start card.

### `select_hand/3`

```prolog
select_hand(Cards, Hand, Cribcards)
```

- **Cards**: List of the 5 or 6 cards dealt to a player at the start of a hand.
- **Hand**: List of 4 of those cards to be kept to form the player's hand.
- **Cribcards**: List of the cards not kept (to be placed in the crib).

The cards to be kept in the hand should be chosen to maximize the expected value of the hand over all possible start cards.

## Assessment Criteria

- **50%**: Correctness of `hand_value/3` implementation.
- **20%**: Quality of selections made by the `select_hand/3` predicate.
- **30%**: Quality of code and documentation, as determined by markers.

Note that timeouts will be imposed on all tests. You will have at least 1 second per test case for `hand_value/3` and 4 seconds per test of `select_hand/3`. Executions taking longer than that may be terminated. Several test cases for `hand_value/3`, along with their correct values, are shown earlier in this assignment.