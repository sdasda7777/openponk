Class {
	#name : #OPDIEdgeLabel,
	#superclass : #OPDILabel,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'as yet unclassified' }
OPDIEdgeLabel >> anchorToEdge [

	roassalShape @ RSDraggable.
	OPRSAnchorConstraint new
		balance: self defaultBalance;
		minDistance: self defaultMinDistance;
		stick: roassalShape on: self owningElement roassalShape
]

{ #category : #'as yet unclassified' }
OPDIEdgeLabel >> defaultBalance [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPDIEdgeLabel >> defaultMinDistance [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPDIEdgeLabel >> renderShapeDetails [

	self anchorToEdge
]

{ #category : #rendering }
OPDIEdgeLabel >> updateRenderFromModel [

	roassalShape
		text: self text;
		signalUpdate.

	(roassalShape propertyAt: OPRSAnchorConstraint) moveShape
]

{ #category : #roassal }
OPDIEdgeLabel >> updateRenderFromSelf [

	bounds ifNil: [ ^ self ].
	super updateRenderFromSelf.
	(roassalShape propertyAt: OPRSAnchorConstraint) saveShapePosition
]
