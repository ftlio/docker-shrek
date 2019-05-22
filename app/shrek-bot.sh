#!/bin/sh

function get_next_quote () {
		next_quote="$(./get-shrek-quote.sh)"
		if [ "$1" = '--to-file' ]; then
				echo "$next_quote" > "$2"
		else
				echo "$next_quote"
		fi
}

if [ -n "$QUOTE_BOT_TTL" ]; then
		for i in `seq 1 $QUOTE_BOT_TTL`
		do
				get_next_quote $1 $2
				sleep 2
		done
else
		while true
		do
				get_next_quote $1 $2
				sleep 2
		done
fi
