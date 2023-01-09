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

	^ name
]

{ #category : #accessing }
OPDIDiagram >> name: anObject [

	name := anObject
]

{ #category : #accessing }
OPDIDiagram >> resolution [

	^ resolution
]

{ #category : #accessing }
OPDIDiagram >> resolution: anObject [

	resolution := anObject
]
