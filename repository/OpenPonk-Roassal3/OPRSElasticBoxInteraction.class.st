Class {
	#name : #OPRSElasticBoxInteraction,
	#superclass : #RSElasticBoxInteraction,
	#instVars : [
		'candidatesBlock'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #'as yet unclassified' }
OPRSElasticBoxInteraction class >> withCandidatesBlock: aBlock [

	^ self new
		  candidatesBlock: aBlock;
		  yourself
]

{ #category : #accessing }
OPRSElasticBoxInteraction >> candidates [
	^ candidatesBlock value
]

{ #category : #accessing }
OPRSElasticBoxInteraction >> candidatesBlock: aBlock [
	candidatesBlock := aBlock
]

{ #category : #accessing }
OPRSElasticBoxInteraction >> color [
	^ Color black alpha: 0.2
]

{ #category : #accessing }
OPRSElasticBoxInteraction >> defaultBox [

	^ super defaultBox
		  color: (Color black alpha: 0.2);
		  yourself
]

{ #category : #initialization }
OPRSElasticBoxInteraction >> initialize [

	super initialize.
	self
		when: RSSelectionChangedEvent
		do: [ :e | e canvas propertyAt: self class put: e selectedShapes ].
	self
		when: RSSelectionEndEvent
		do: [ :e | e canvas propertyAt: self class put: e selectedShapes ]
]

{ #category : #hooks }
OPRSElasticBoxInteraction >> onShape: aCanvas [

	super onShape: aCanvas.
	aCanvas when: RSMouseLeftClick do: [ :evt | 
		selectedShapes := RSGroup new.
		aCanvas propertyAt: self class put: #(  ) ]
]

{ #category : #helper }
OPRSElasticBoxInteraction >> selectedShapesWith: shape [

	| rect candidates |
	candidates := self candidates asSet copyWithout: shape.

	rect := shape encompassingRectangle.

	^ (targetShapes rsValue: shape canvas) select: [ :node | 
		  (candidates includes: node) and: [ 
			  node encompassingRectangle intersects: rect ] ]
]
