# Hickory

Hickory is a decision tree learning library for the Haskell programming
language. It is not anywhere close to finished, so don't judge. 

## Overview

Hickory decision trees are recursive structures consisting of a a left and
right subtree, and a predicate function (type `a -> Bool`). When a trained tree
is used to classify a record, at each node of the tree, the traversal will
continue to the left if this function returns false, right if it returns true.

To build a tree, you need two things: a list of predicate functions that can be
used to distinguish different documents, and a list of document-category pairs
for training the tree with. For a document classifier based on words, each of
these functions might test the inclusion of a word, or some statistical
measurement of the text. Each of these functions will be used a maximum of once
in the final trained tree. It's not guaranteed that all distinguishing
functions will be needed, nor that all will end up in the returned tree.

## License

(c) 2012 Max Thom Stahl (max@villainousindustri.es / github.com/mstahl).

Released under the MIT license.