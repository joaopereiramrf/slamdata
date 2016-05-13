module SlamData.Workspace.Deck.Component.ChildSlot where

import SlamData.Prelude

import Halogen.Component.ChildPath (ChildPath, cpL, cpR)

import SlamData.Workspace.Card.Component (CardQueryP, CardStateP)
import SlamData.Workspace.Card.CardId (CardId)
import SlamData.Workspace.Deck.BackSide.Component as Back


newtype CardSlot = CardSlot CardId

derive instance genericCardSlot :: Generic CardSlot
instance eqCardSlot :: Eq CardSlot where eq = gEq
instance ordCardSlot :: Ord CardSlot where compare = gCompare

type BackSideSlot = Unit

type ChildSlot =
  Either CardSlot BackSideSlot

type ChildQuery =
  Coproduct CardQueryP Back.Query

type ChildState =
  Either CardStateP Back.State


cpCard
  ∷ ChildPath
      CardStateP ChildState
      CardQueryP ChildQuery
      CardSlot ChildSlot
cpCard = cpL

cpBackSide
  ∷ ChildPath
      Back.State ChildState
      Back.Query ChildQuery
      BackSideSlot ChildSlot
cpBackSide = cpR