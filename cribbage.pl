% Author: William Spongberg, Student ID: 1354263
% Prolog program to calculate and select the best scoring hand in Cribbage.

% It defines the ranks and suits of a standard deck of cards, generates all possible combinations of cards, 
% and includes predicates to find sublists, convert cards to positions, and create dictionaries from cards.
% The program calculates the value of a hand based on various Cribbage scoring rules, such as fifteens, pairs, runs, flushes, and "one for his nob".
% It also includes functionality to select the best hand from a given set of cards, discarding the rest to the crib.
% The approach involves generating all possible hands, calculating their average values over all possible start cards, and selecting the hand with the highest average value.

% rank(?Rank, ?Position, ?Value).
% Defines the rank, position, and value of each card in a standard deck.
rank(ace, 1, 1).
rank(2, 2, 2).
rank(3, 3, 3).
rank(4, 4, 4).
rank(5, 5, 5).
rank(6, 6, 6).
rank(7, 7, 7).
rank(8, 8, 8).
rank(9, 9, 9).
rank(10, 10, 10).
rank(jack, 11, 10).
rank(queen, 12, 10).
rank(king, 13, 10).

% suit(?Suit).
% Defines the suits in a standard deck.
suit(clubs).
suit(diamonds).
suit(hearts).
suit(spades).

% card(?Rank, ?Suit)
% Defines a card by its rank and suit.
card(R, S) :- rank(R, _, _), suit(S).

% deck(-Deck)
% Generates a deck of 52 cards with all possible combinations of ranks and
% suits.
deck(Deck) :- findall(card(R, S), card(R, S), Deck).

% sublist(?Sublist, +List)
% Finds all sublists of a given list.
sublist([], []).
sublist([H | L1], [H | L2]) :- sublist(L1, L2).
sublist(L1, [_ | L2]) :- sublist(L1, L2).

% cards_to_pos(+Cards, -Pos)
% Converts a list of cards to their respective positions.
cards_to_pos([], []).
cards_to_pos([card(R, _) | Cards], [P | Pos]) :-
    rank(R, P, _),
    cards_to_pos(Cards, Pos).

% create_dict(+Keys, +Values, -Dict)
% Creates pairs from keys and values.
create_dict([], [], []).
create_dict([K | Keys], [V | Values], [K-V | Dict]) :-
    create_dict(Keys, Values, Dict).

% create_cards_dict(+Cards, -Dict)
% Creates a dictionary from cards and their positions.
create_cards_dict(Cards, Dict) :-
    cards_to_pos(Cards, Pos),
    create_dict(Pos, Cards, Dict).

% get_dict_values(+Dict, -Values)
% Extracts values from a dictionary.
get_dict_values([], []).
get_dict_values([_-V | Dict], [V | Values]) :-
    get_dict_values(Dict, Values).

% find_max_dict_val(+Dict, -Max)
% Finds the maximum value in a dictionary.
find_max_dict_val(Dict, Max) :- find_max_dict_val(Dict, 0, Max).
find_max_dict_val([], Max, Max).
find_max_dict_val([_-V | Dict], Acc, Max) :-
    (V > Acc -> Acc0 is V ; Acc0 is Acc),
    find_max_dict_val(Dict, Acc0, Max).

% dict_get(+Dict, ?V, ?K)
% Retrieves a key from a dictionary given a value.
dict_get([K-V | _], V, K) :- !.
dict_get([_ | Dict], V, K) :- dict_get(Dict, V, K).

% card_sort(+Cards, -SortedCards)
% Sorts cards by their positions.
card_sort(Cards, SortedCards) :-
    create_cards_dict(Cards, Dict),
    keysort(Dict, SortedDict),
    get_dict_values(SortedDict, SortedCards).

% fifteens(+Cards, -Combos)
% Finds all combinations of cards that sum to 15.
fifteens([], []).
fifteens(Cards, Combos) :-
    sublist(Combos, Cards),
    card_sum(Combos, 15).

% card_sum(+Cards, -Sum)
% Sums the values of a list of cards.
card_sum([], 0).
card_sum([card(R, _) | Cards], Sum) :-
    rank(R, _, Value),
    card_sum(Cards, Rest),
    Sum is Value + Rest.

% pairs(+Cards, -Pairs)
% Finds all pairs of cards with the same rank.
pairs([], []).
pairs(Cards, Pairs) :-
    sublist(Pairs, Cards),
    Pairs = [card(R1, _), card(R2, _)],
    R1 = R2.

% runs(+Cards, -C)
% Finds all runs of 3 or more consecutive cards.
runs([], []).
runs(Cards, Run) :-
    sublist(Run, Cards),
    length(Run, RunLen),
    RunLen >= 3,
    is_consecutive(Run).

% is_consecutive(+Cards)
% Checks if a list of cards are consecutive.
is_consecutive([]).
is_consecutive([_]).
is_consecutive([card(R1, _), card(R2, _) | Cards]) :-
    rank(R1, Pos1, _),
    rank(R2, Pos2, _),
    Pos2 is Pos1 + 1,
    is_consecutive([card(R2, _) | Cards]).

% distinct_runs(+Cards, -DistinctRuns)
% Finds all distinct runs, excluding subruns.
distinct_runs(Cards, DistinctRuns) :-
    findall(Run, runs(Cards, Run), Runs),
    exclude(is_subrun_of_list(Runs), Runs, DistinctRuns).

% is_subrun_of_list(+AllRuns, +Run)
% Checks if Run is a subrun of any run in Runs.
is_subrun_of_list(Runs, Run) :-
    member(OtherRun, Runs),
    subrun(Run, OtherRun).

% subrun(+SubRun, +Run)
% Checks if SubRun is a sublist of Run.
subrun(SubRun, Run) :-
    sublist(SubRun, Run),
    length(SubRun, SubLen),
    length(Run, RunLen),
    SubLen < RunLen.

% flush(+Hand)
% Checks if all cards in a hand are of the same suit.
flush(Hand) :-
    Hand = [card(_, S) | _],
    maplist(has_suit(S), Hand).

% has_suit(+Suit, +Card)
% Helper predicate to check if a card has a specific suit.
has_suit(S, card(_, S)).

% one_for_his_nob(+Cards, +StartCard)
% Checks if the hand has a jack that matches the suit of the start card.
one_for_his_nob(Cards, card(_, StartS)) :-
    member(card(jack, StartS), Cards).

% hand_value(+Hand, +StartCard, -Value)
% Calculates the value of a hand based on various scoring rules.
hand_value(Hand, StartCard, Value) :-
    card_sort([StartCard | Hand], SortedCards),
    score_fifteens(SortedCards, Fifteens),
    score_pairs(SortedCards, Pairs),
    score_runs(SortedCards, Runs),
    score_flush(Hand, StartCard, Flush),
    score_nob(Hand, StartCard, Nob),
    Value is Fifteens + Pairs + Runs + Flush + Nob.

% score_fifteens(+Cards, -Score)
% Counts the number of fifteens in the hand.
score_fifteens(Cards, Score) :-
    findall(Combos, fifteens(Cards, Combos), FifteensList),
    length(FifteensList, Score0),
    Score is Score0 * 2.

% score_pairs(+Cards, -Score)
% Counts the number of pairs in the hand.
score_pairs(Cards, Score) :-
    findall(Pairs, pairs(Cards, Pairs), PairsList),
    length(PairsList, Score0),
    Score is Score0 * 2.

% score_runs(+Cards, -Score)
% Counts the number of runs in the hand.
score_runs(Cards, Score) :-
    distinct_runs(Cards, Runs),
    sum_sublist_lengths(Runs, Score).

% sum_sublist_lengths(+Sublists, -Sum)
% Sums the lengths of all sublists.
sum_sublist_lengths([], 0).
sum_sublist_lengths([Sublist | Rest], Sum) :-
    length(Sublist, Length),
    sum_sublist_lengths(Rest, RestSum),
    Sum is Length + RestSum.

% score_flush(+Hand, +StartCard, -Score)
% Scores a flush in the hand.
score_flush(Hand, StartCard, Score) :-
    (flush([StartCard | Hand]) -> Score is 5 ;
     flush(Hand) -> Score is 4 ;
     Score is 0).

% score_nob(+Hand, +StartCard, -Score)
% Checks if the hand has a nob.
score_nob(Hand, StartCard, Score) :-
    (one_for_his_nob(Hand, StartCard) -> Score is 1 ; Score is 0).

% select_hand(+Cards, -Hand, -CribCards)
% Selects the best hand from a given set of cards, discarding the rest to the
% crib.
select_hand([], [], []).
select_hand(Cards, Hand, CribCards) :-
    findall(Hand, pick_cards(Cards, Hand), Hands),
    find_all_hand_avgs(Cards, Hands, Dict),
    find_max_dict_val(Dict, Max),
    dict_get(Dict, Max, Hand),
    subtract(Cards, Hand, CribCards).

% find_all_hand_avgs(+Cards, +Hands, -Dict)
% Finds the average value of all possible hands.
find_all_hand_avgs(_, [], []).
find_all_hand_avgs(Cards, [Hand | Hands], [Hand-Avg | Dict]) :-
    start_cards(Cards, StartCards),
    avg_hand_value(Hand, StartCards, Avg),
    find_all_hand_avgs(Cards, Hands, Dict).

% pick_cards(+Cards, -Pick)
% Picks 4 cards from a given set of cards.
pick_cards(Cards, Pick) :-
    sublist(Pick, Cards),
    length(Pick, 4).

% start_cards(+Cards, -Start)
% Finds all possible start cards by subtracting the given cards from the deck.
start_cards(Cards, Start) :-
    deck(Deck),
    subtract(Deck, Cards, Start).

% avg_hand_value(+Hand, +StartCards, -Avg)
% Finds the average value of a hand over all possible start cards.
avg_hand_value(Hand, StartCards, Avg) :-
    tot_all_hand_value(Hand, StartCards, TotVal),
    length(StartCards, StartLen),
    Avg is TotVal / StartLen.

% tot_all_hand_value(+Hand, +StartCards, -Val)
% Finds the total value of all possible hands, using Acc as an accumulator.
tot_all_hand_value([], [], 0).
tot_all_hand_value(Hand, StartCards, TotVal) :-
    tot_all_hand_value(Hand, StartCards, 0, TotVal).

% tot_all_hand_value(+Hand, +StartCards, +Acc, -TotVal)
tot_all_hand_value(_, [], TotVal, TotVal).
tot_all_hand_value(Hand, [C | StartCards], Acc, TotVal) :-
    hand_value(Hand, C, Val),
    Acc0 is Acc + Val,
    tot_all_hand_value(Hand, StartCards, Acc0, TotVal).