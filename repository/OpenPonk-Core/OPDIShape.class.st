Class {
	#name : #OPDIShape,
	#superclass : #OPDIDiagramElement,
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
