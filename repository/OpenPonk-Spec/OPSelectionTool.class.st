"
A palette item used for selecting items in the view.
This class should not be used directly and is created automatically with every DCPalette.
"
Class {
	#name : #OPSelectionTool,
	#superclass : #OPPaletteTool,
	#instVars : [
		'selectedControllers'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #protocol }
OPSelectionTool >> deselect [

	(self diagramController canvas propertyAt: OPRSSelectableCanvas)
		disableMultiselect.
	self selectedControllers: { }
]

{ #category : #accessing }
OPSelectionTool >> palette: aPalette [

	palette ifNotNil: [ 
		self diagramController ifNotNil: [ 
			self diagramController announcer unsubscribe: self ] ].
	super palette: aPalette
]

{ #category : #protocol }
OPSelectionTool >> select [

	selectedControllers := {  }
]

{ #category : #protocol }
OPSelectionTool >> selectedControllers: aCollectionOfControllers [

	selectedControllers , aCollectionOfControllers
		detect: [ :any | any hasProperty: OPRSSelectable ]
		ifFound: [ :ctrl | 
			(ctrl propertyAt: OPRSSelectable) doHighlightShapes:
				(aCollectionOfControllers collect: #figure) ].
	selectedControllers := aCollectionOfControllers.
	self editor openFormOn: (aCollectionOfControllers size = 1
			 ifTrue: [ aCollectionOfControllers anyOne ]
			 ifFalse: [ nil ])
]
