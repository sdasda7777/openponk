Class {
	#name : #OPDIEdge,
	#superclass : #OPDIDiagramElement,
	#instVars : [
		'source',
		'target',
		'waypoints'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPDIEdge >> source [

	^ source
]

{ #category : #accessing }
OPDIEdge >> source: anElement [

	source := SRToOneLink
		          on: self
		          slot: #source
		          oppositeSlot: #sourceEdges
		          updateFrom: source
		          to: anElement
]

{ #category : #accessing }
OPDIEdge >> target [

	^ target
]

{ #category : #accessing }
OPDIEdge >> target: anElement [

	target := SRToOneLink
		          on: self
		          slot: #target
		          oppositeSlot: #targetEdges
		          updateFrom: target
		          to: anElement
]

{ #category : #accessing }
OPDIEdge >> waypoints [

	^ waypoints
]

{ #category : #accessing }
OPDIEdge >> waypoints: anObject [

	waypoints := anObject
]
