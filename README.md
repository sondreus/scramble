# Scramble

Scramble takes a list of sensitive terms and replaces them with a combination of words or characters that sound the same. The live app currently only supports Mandarin Chinese.

You can try it out here: https://amaze.shinyapps.io/scramble/

All suggestions welcome. Of particular help would be a larger Chinese dictionary, as well as an updated list of sensitive terms.

The algorithm takes as inputs:
* A dictionary of words and their sound
* A list of sensitive terms
* A text to scramble
* **n** = an integer, specifying how many different replacements of a sensitive term to generate

The algorithm then:
* Identifies the sensitive terms present in the text
* Generates **n** possible replacements for these terms
* Replaces the terms with the text with these replacements, sampling randomly from them
* Returns the scrambled text

