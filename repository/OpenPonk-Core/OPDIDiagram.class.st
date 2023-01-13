Class {
	#name : #OPDIDiagram,
	#superclass : #OPDIShape,
	#instVars : [
		'name',
		'documentation',
		'resolution'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPDIDiagram >> documentation [

	^ documentation
]

{ #category : #accessing }
OPDIDiagram >> documentation: anObject [

	documentation := anObject
]

{ #category : #accessing }
OPDIDiagram >> name [

	^ name ifNil: [ self modelElement name ]
]

{ #category : #accessing }
OPDIDiagram >> name: anObject [

	name := anObject
]

{ #category : #rendering }
OPDIDiagram >> render [

	"there is currently no way to render a diagram directly (only update existing Roassal canvas)"

	^ self notYetImplemented
]

{ #category : #accessing }
OPDIDiagram >> resolution [

	^ resolution
]

{ #category : #accessing }
OPDIDiagram >> resolution: anObject [

	resolution := anObject
]

{ #category : #'as yet unclassified' }
OPDIDiagram >> updateFromRender [

	self bounds: (OPDIBounds
			 withPosition: 0 @ 0
			 extent: roassalShape encompassingRectangle extent)
]

{ #category : #'as yet unclassified' }
OPDIDiagram >> updateRenderFromSelf [

	"do nothing (canvases are infinite in OP)"

	
]
