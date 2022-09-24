#include "shuffle.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static void printDeck(CardDeck deck)
{
	int ind;
	for (ind = 0; ind < deck.size; ind ++)
	{
		printf("%c ", deck.cards[ind]);
	}
	printf("\n");
}

void divide(CardDeck origDeck, CardDeck * leftDeck, CardDeck * rightDeck)
{
	int count = 1;

	while (count < origDeck.size)
	{
		memcpy(leftDeck[count - 1].cards, origDeck.cards, count * sizeof(char));
		leftDeck[count - 1].size = count;

		memcpy(rightDeck[count - 1].cards, &origDeck.cards[count], (origDeck.size - count ) * sizeof(char));
		rightDeck[count - 1].size = (origDeck.size - count);

		count++;
	}

}

void helper(CardDeck finalDeck, CardDeck leftDeck, CardDeck rightDeck, int nFinal, int nLeft, int nRight, int round)
{
	if (nLeft == 0)
	{
		memcpy(finalDeck.cards, rightDeck.cards, nRight * sizeof(char));
		round = round - 1;

		if (round > 0)
		{
			shuffle(finalDeck, round); 
		}

		else
		{
			printDeck(finalDeck);
		}

		return;
	}

	if (nRight == 0)
	{
		memcpy(finalDeck.cards, leftDeck.cards, nLeft * sizeof(char));

		round = round - 1;

		if (round > 0)
		{
			shuffle(finalDeck, round);
		}

		else
		{
			printDeck(finalDeck);
		}

		return;
	}

	finalDeck.cards[nFinal - 1] = leftDeck.cards[nLeft - 1];

	helper(finalDeck, leftDeck, rightDeck, nFinal - 1, nLeft - 1, nRight, round);

	finalDeck.cards[nFinal - 1] = rightDeck.cards[nRight - 1];

	helper(finalDeck, leftDeck, rightDeck, nFinal - 1, nLeft, nRight - 1, round);
}

void interleave(CardDeck leftDeck, CardDeck rightDeck, int round)
{
	CardDeck finalDeck;
	finalDeck.size = leftDeck.size + rightDeck.size;

	helper(finalDeck, leftDeck, rightDeck, finalDeck.size, leftDeck.size, rightDeck.size, round);
}

void shuffle(CardDeck origDeck, int round)
{
	int decks = origDeck.size - 1;

	CardDeck * leftDeck = malloc(decks * sizeof(CardDeck));
	CardDeck * rightDeck = malloc(decks * sizeof(CardDeck));

	divide(origDeck, leftDeck, rightDeck);

	for (int i = 0; i < decks; i++)
	{
		interleave(leftDeck[i], rightDeck[i], round);
	}

	free(leftDeck);
	free(rightDeck);
}
