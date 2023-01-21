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

{ #category : #testing }
OPDIDiagram >> isRendered [

	^ roassalShape isNotNil
]

{ #category : #accessing }
OPDIDiagram >> name [

	^ name ifNil: [ self modelElement name ]
]

{ #category : #accessing }
OPDIDiagram >> name: anObject [

	name := anObject
]

{ #category : #'as yet unclassified' }
OPDIDiagram >> ownedElementRenderedIn: aCanvas [

	roassalShape ifNotNil: [ ^ self ].
	super ownedElementRenderedIn: aCanvas.
	roassalShape := aCanvas.
	self updateRenderFromSelf
]

{ #category : #rendering }
OPDIDiagram >> renderBasicShape [

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
			 extent: roassalShape encompassingRectangle extent).
	self ownedElements do: #updateFromRender
]

{ #category : #'as yet unclassified' }
OPDIDiagram >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	self ownedElements do: #updateRenderFromSelf.
	roassalShape signalUpdate
]
