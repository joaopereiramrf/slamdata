module SlamData.Workspace.Card.BuildChart.Gauge.Model where

import SlamData.Prelude

import Data.Argonaut (JCursor, Json, decodeJson, (~>), (:=), isNull, jsonNull, (.?), jsonEmptyObject)
import Data.Foldable as F

import SlamData.Workspace.Card.Chart.Aggregation as Ag

import Test.StrongCheck.Arbitrary (arbitrary)
import Test.StrongCheck.Gen as Gen
import Test.Property.ArbJson (runArbJCursor)

type GaugeR =
  { value ∷ JCursor
  , valueAggregation ∷ Ag.Aggregation
  , parallel ∷ Maybe JCursor
  , multiple ∷ Maybe JCursor
  }

type Model = Maybe GaugeR

initialModel ∷ Model
initialModel = Nothing

eqGaugeR ∷ GaugeR → GaugeR → Boolean
eqGaugeR r1 r2 =
  F.and
    [ r1.value ≡ r2.value
    , r1.valueAggregation ≡ r2.valueAggregation
    , r1.parallel ≡ r2.parallel
    , r1.multiple ≡ r2.multiple
    ]

eqModel ∷ Model → Model → Boolean
eqModel Nothing Nothing = true
eqModel (Just r1) (Just r2) = eqGaugeR r1 r2
eqModel _ _ = false

genModel ∷ Gen.Gen Model
genModel = do
  isNothing ← arbitrary
  if isNothing
    then pure Nothing
    else do
    value ← map runArbJCursor arbitrary
    valueAggregation ← arbitrary
    parallel ← map (map runArbJCursor) arbitrary
    multiple ← map (map runArbJCursor) arbitrary
    pure
      $ Just { value
             , valueAggregation
             , parallel
             , multiple
             }

encode ∷ Model → Json
encode Nothing = jsonNull
encode (Just r) =
  "configType" := "gauge"
  ~> "value" := r.value
  ~> "valueAggregation" := r.valueAggregation
  ~> "parallel" := r.parallel
  ~> "multiple" := r.multiple
  ~> jsonEmptyObject

decode ∷ Json → String ⊹ Model
decode js
  | isNull js = pure Nothing
  | otherwise = do
    obj ← decodeJson js
    configType ← obj .? "configType"
    unless (configType ≡ "gauge")
      $ throwError "This config is not gauge"
    value ← obj .? "value"
    valueAggregation ← obj .? "valueAggregation"
    parallel ← obj .? "parallel"
    multiple ← obj .? "multiple"
    pure $ Just { value
                , valueAggregation
                , parallel
                , multiple
                }
