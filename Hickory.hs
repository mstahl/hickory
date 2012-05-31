module Hickory (buildTree, evalTree) where

import Data.List (group, partition, sort)

type Differentiator document = (document -> Bool)

data Tree document category = Node (Tree document category) (Differentiator document) (Tree document category) 
                            | Leaf category

buildTree :: (Eq category, Ord category) => [Differentiator document] -> [(document, category)] -> Tree document category
buildTree differentiators training_data = 
  if all (\c -> c == (snd $ head training_data)) $ map (snd) training_data
  then Leaf (snd $ head training_data)
  else Node a best b
       where best_index       = bestDifferentiatorIndex differentiators training_data
             best             = differentiators !! best_index
             differentiators' = deleteAt best_index differentiators
             (with, without)  = partition (best . fst) training_data
             a                = buildTree differentiators' without
             b                = buildTree differentiators' with

evalTree :: Tree document category -> document -> category
evalTree (Leaf category) _ = category
evalTree (Node no diff yes) document = if diff document
                                       then evalTree yes document
                                       else evalTree no document 

-- Private (non-exported) functions

deleteAt 0 (x:xs) = xs
deleteAt i (x:xs) = x : deleteAt (i - 1) xs

-- TODO: Write a for-real one of these. 
bestDifferentiatorIndex differentiators training_data = 
  do let differentiators_igs = zip (map (informationGain training_data) differentiators) differentiators
         

entropy :: (Floating t, Ord category) => [(document, category)] -> t
entropy pairs = let counts = map (fromIntegral . length) $ group $ sort $ map (snd) pairs
                    total  = fromIntegral $ length pairs
                in (-1) * (sum $ map (\p -> p * (logBase 2.0 p)) $ map (\c -> c / total) counts)

informationGain :: (Floating t, Eq category, Ord category) => Differentiator document -> [(document, category)] -> t
informationGain training_data differentiator = 
  let (with, without) = partition (differentiator . fst) training_data
      entropy_with    = ((fromIntegral $ length with) / (fromIntegral $ length training_data) * (entropy with))
      entropy_without = ((fromIntegral $ length without) / (fromIntegral $ length training_data) * (entropy without))
  in (entropy training_data) - entropy_with - entropy_without

