Class {
	#name : #OPDIShape,
	#superclass : #OPDIDiagramElement,
	#traits : 'RSTPositionable',
	#classTraits : 'RSTPositionable classTrait',
	#instVars : [
		'bounds'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPDIShape >> bounds [

	^ bounds
]

{ #category : #accessing }
OPDIShape >> bounds: anObject [

	bounds := anObject
]

{ #category : #accessing }
OPDIShape >> encompassingRectangle [

	^ roassalShape encompassingRectangle
]

{ #category : #accessing }
OPDIShape >> extent [

	^ roassalShape extent
]

{ #category : #accessing }
OPDIShape >> height [

	^ roassalShape height
]

{ #category : #accessing }
OPDIShape >> position [

	^ roassalShape position
]

{ #category : #actions }
OPDIShape >> translateBy: deltaAsPoint [

	"Move a shape by a delta value, expressed as a point"

	roassalShape translateBy: deltaAsPoint
]

{ #category : #actions }
OPDIShape >> translateTo: aPoint [

	"Translate a shape to a new position, expressed as a point"

	roassalShape translateTo: aPoint
]

{ #category : #'as yet unclassified' }
OPDIShape >> updateFromRender [

	self bounds: (OPDIBounds
			 withPosition: roassalShape position
			 extent: roassalShape extent)
]

{ #category : #roassal }
OPDIShape >> updateRenderFromSelf [

	bounds ifNil: [ ^ self ].
	roassalShape
		extent: bounds extent;
		translateTo: bounds position
]

{ #category : #accessing }
OPDIShape >> width [

	^ roassalShape width
]
