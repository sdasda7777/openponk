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

{ #category : #rendering }
OPDIEdge class >> renderForController: aController [

	^ self new
		  modelElement: aController model;
		  source: aController source diagramElement;
		  target: aController target diagramElement;
		  renderIn: aController diagramController canvas;
		  yourself
]

{ #category : #rendering }
OPDIEdge class >> renderSimplifiedForController: aController [

	^ self new
		  modelElement: aController model;
		  source: aController source diagramElement;
		  target: aController target diagramElement;
		  renderBasicShapeIn: aController diagramController canvas;
		  yourself
]

{ #category : #deprecated }
OPDIEdge >> from [

	self
		deprecated: 'Use #source'
		transformWith: '`@receiver from' -> '`@receiver source'.
	^ self source
]

{ #category : #removing }
OPDIEdge >> remove [

	super remove.
	self source: nil.
	self target: nil
]

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

{ #category : #deprecated }
OPDIEdge >> to [

	self
		deprecated: 'Use #target'
		transformWith: '`@receiver to' -> '`@receiver target'.
	^ self target
]

{ #category : #'as yet unclassified' }
OPDIEdge >> updateFromRender [

	self waypoints: roassalShape controlPoints.
	super updateFromRender
]

{ #category : #'as yet unclassified' }
OPDIEdge >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	waypoints ifNotNil: [ roassalShape controlPoints: waypoints ].
	super updateRenderFromSelf
]

{ #category : #accessing }
OPDIEdge >> waypoints [

	^ waypoints
]

{ #category : #accessing }
OPDIEdge >> waypoints: anObject [

	waypoints := anObject
]
