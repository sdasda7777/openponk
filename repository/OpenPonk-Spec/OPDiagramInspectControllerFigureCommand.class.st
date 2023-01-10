Class {
	#name : #OPDiagramInspectControllerFigureCommand,
	#superclass : #OPDiagramFigureDevCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPDiagramInspectControllerFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $i shift meta for: OPCanvasPresenter
]

{ #category : #accessing }
OPDiagramInspectControllerFigureCommand >> defaultMenuIcon [

	^ self iconNamed: #glamorousInspect
]

{ #category : #accessing }
OPDiagramInspectControllerFigureCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect controller'.
	controllers ifNil: [ ^ basicName ].
	^ controllers size pluralize: basicName
]

{ #category : #execution }
OPDiagramInspectControllerFigureCommand >> execute [

	(figures collect: [ :each | 
		 diagramController controllerForRoassalShape: each ]) inspect
]
