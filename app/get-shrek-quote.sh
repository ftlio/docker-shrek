#!/bin/sh
head -$((${RANDOM} % `wc -l < quotes.txt` + 1)) quotes.txt | tail -1
