{-
Copyright 2015 SlamData, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-}

module Dashboard.Component.State where

import Prelude

import DOM.Event.EventTarget (EventListener())
import Dashboard.Menu.Component.Query (Value(), notebookQueryToValue)
import Data.BrowserFeatures (BrowserFeatures())
import Data.Shortcut as Shortcut
import Data.Lens (LensP(), lens)
import Data.Maybe (Maybe(..))
import Data.Path.Pathy (rootDir)
import Data.StrMap (StrMap(), fromFoldable)
import Data.Tuple (Tuple(..))
import Model.AccessType (AccessType(..))
import Model.CellId (CellId())
import Model.CellType (CellType(..))
import Notebook.Component as Notebook
import Notebook.Effects (NotebookEffects())
import Utils.Path (DirPath())

type NotebookShortcut = { shortcut :: Shortcut.Shortcut, value :: Value, label :: Maybe String }

type State =
  { accessType :: AccessType
  , browserFeatures :: BrowserFeatures
  , notebookShortcuts :: StrMap NotebookShortcut
  , keyboardListeners :: Array (EventListener NotebookEffects)
  , loaded :: Boolean
  , path :: DirPath
  , viewingCell :: Maybe CellId
  , version :: Maybe String
  }

notebookShortcuts :: StrMap NotebookShortcut
notebookShortcuts =
  fromFoldable
    [ Tuple
        "NotebookPublish"
        { shortcut: Shortcut.modP
        , value: notebookQueryToValue $ (Notebook.Publish) unit
        , label: Nothing
        }
    , Tuple
        "InsertQuery"
        { shortcut: Shortcut.altModOne
        , value: notebookQueryToValue $ (Notebook.AddCell Query) unit
        , label: Nothing
        }
    , Tuple
        "InsertMarkdown"
        { shortcut: Shortcut.altModTwo
        , value: notebookQueryToValue $ (Notebook.AddCell Markdown) unit
        , label: Nothing
        }
    , Tuple
        "InsertExplore"
        { shortcut: Shortcut.altModThree
        , value: notebookQueryToValue $ (Notebook.AddCell Explore) unit
        , label: Nothing
        }
    , Tuple
        "InsertSearch"
        { shortcut: Shortcut.altModFour
        , value: notebookQueryToValue $ (Notebook.AddCell Search) unit
        , label: Nothing
        }
    , Tuple
        "CellEvaluate"
        { shortcut: Shortcut.modEnter
        , value: notebookQueryToValue $ (Notebook.RunActiveCell) unit
        , label: Nothing
        }
    ]

initialState :: { browserFeatures :: BrowserFeatures } -> State
initialState rec =
  { accessType: Editable
  , browserFeatures: rec.browserFeatures
  , notebookShortcuts: notebookShortcuts
  , keyboardListeners: []
  , loaded: false
  , path: rootDir
  , viewingCell: Nothing
  , version: Nothing
  }

_accessType :: LensP State AccessType
_accessType = lens _.accessType _{accessType = _}

_browserFeatures :: LensP State BrowserFeatures
_browserFeatures = lens _.browserFeatures _{browserFeatures = _}

_notebookShortcuts :: LensP State (StrMap NotebookShortcut)
_notebookShortcuts = lens _.notebookShortcuts _{notebookShortcuts = _}

_keyboardListeners :: LensP State (Array (EventListener NotebookEffects))
_keyboardListeners = lens _.keyboardListeners _{keyboardListeners = _}

_loaded :: LensP State Boolean
_loaded = lens _.loaded _{loaded = _}

_path :: LensP State DirPath
_path = lens _.path _{path = _}

_viewingCell :: LensP State (Maybe CellId)
_viewingCell = lens _.viewingCell _{viewingCell = _}

_version :: LensP State (Maybe String)
_version = lens _.version _{version = _}
