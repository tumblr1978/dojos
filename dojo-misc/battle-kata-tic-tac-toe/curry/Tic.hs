module Tic
where

data MoveType = Win | Counter | Setup | Regular deriving (Eq, Ord, Enum, Show)
data Player = X | O deriving (Eq, Ord, Enum, Show)
type Cell = Maybe Player
type Row = [Cell]
type Board = [Row]
type Move = (Int, MoveType)

nextMove :: Player -> Board -> Move
nextMove player board 
            | isEmpty board = (4, Setup)
            | isClassicSetup player board = (0, Counter)
            | otherwise = playBestMove player board

isEmpty :: Board -> Bool
isEmpty = all id . map (all (\x -> x == Nothing))

isClassicSetup :: Player -> Board -> Bool
isClassicSetup X [[Nothing, Nothing,Nothing],[Nothing, Just O, Nothing], [Nothing, Nothing, Nothing]] = True
isClassicSetup O [[Nothing, Nothing,Nothing],[Nothing, Just X, Nothing], [Nothing, Nothing, Nothing]] = True
isClassicSetup _ _ = False

playBestMove :: Player -> Board -> Move
playBestMove player board = (cast (fst . play $ board), Regular) 

cast :: Maybe Int -> Int
cast (Just a) = a
cast Nothing = 0

play = foldl hack (Nothing, 0)

hack :: (Maybe Int, Int) -> Row -> (Maybe Int, Int)
hack acc = foldl hack2 acc 

hack2 :: (Maybe Int, Int) -> Cell -> (Maybe Int, Int)
hack2 (Nothing, index) Nothing = (Just index, index + 1)
hack2 (Nothing, index) cell = (Nothing, index + 1)
hack2 (found, index) _ = (found, index + 1)

foo :: Row -> Int
foo = fst . foldl bar (0, Nothing) 

bar :: (Int, Cell) -> Cell -> (Int, Cell)
bar (weight, previousCell) Nothing = (weight, previousCell)
bar (weight, previousCell) cell
        | cell == previousCell = (weight + 1, cell)
        | otherwise = (1, cell)
