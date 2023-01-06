Class {
	#name : #OPRSAnchorConstraint,
	#superclass : #RSObject,
	#instVars : [
		'minDistance',
		'balance',
		'anchorShape',
		'guideLine',
		'shape',
		'line'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #building }
OPRSAnchorConstraint >> addAnchorAndGuideLine [

	self anchorShape isInACanvas ifTrue: [ ^ self ].
	shape canvas add: self anchorShape.
	self guideLine from: shape to: self anchorShape.
	shape canvas add: self guideLine
]

{ #category : #building }
OPRSAnchorConstraint >> anchorShape [

	anchorShape ifNotNil: [ ^ anchorShape ].
	anchorShape := RSBox new.
	anchorShape
		size: 0;
		color: Color red.
	^ anchorShape
]

{ #category : #accessing }
OPRSAnchorConstraint >> balance [
	^ balance
]

{ #category : #accessing }
OPRSAnchorConstraint >> balance: aNumber [
	balance := aNumber
]

{ #category : #building }
OPRSAnchorConstraint >> build [

	line when: RSShapeRemovedEvent do: [ self remove ].
	line from when: RSPositionChangedEvent do: [ self update ].
	line to when: RSPositionChangedEvent do: [ self update ].
	shape when: RSMouseLeftDragStart do: [ self addAnchorAndGuideLine ].
	shape when: RSMouseDragEnd do: [ self removeAnchorAndGuideLine ]
]

{ #category : #accessing }
OPRSAnchorConstraint >> createUpdater [

	^ OPRSAnchorConstraintUpdater new
		  line: line;
		  shape: shape;
		  anchorShape: anchorShape;
		  balance: balance;
		  minDistance: minDistance;
		  yourself
]

{ #category : #building }
OPRSAnchorConstraint >> guideLine [

	guideLine ifNotNil: [ ^ guideLine ].
	guideLine := RSLine new.
	self useGuideLine.
	^ guideLine
]

{ #category : #accessing }
OPRSAnchorConstraint >> line [
	^ line
]

{ #category : #building }
OPRSAnchorConstraint >> lineLength [

	^ self segments sumNumbers: [ :pair | 
		  pair first distanceTo: pair second ]
]

{ #category : #accessing }
OPRSAnchorConstraint >> minDistance [
	^ minDistance
]

{ #category : #accessing }
OPRSAnchorConstraint >> minDistance: anInteger [
	minDistance := anInteger
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> noGuideLine [

	self guideLine color: Color transparent
]

{ #category : #building }
OPRSAnchorConstraint >> remove [

	shape announcer unsubscribe: self.
	line from announcer unsubscribe: self.
	line to announcer unsubscribe: self.
	self removeAnchorAndGuideLine
]

{ #category : #building }
OPRSAnchorConstraint >> removeAnchorAndGuideLine [

	anchorShape ifNotNil: [ anchorShape remove ].
	guideLine ifNotNil: [ guideLine remove ]
]

{ #category : #accessing }
OPRSAnchorConstraint >> shape [
	^ shape
]

{ #category : #building }
OPRSAnchorConstraint >> stick: aShape on: aLine [

	shape := aShape.
	line := aLine.
	self build
]

{ #category : #updating }
OPRSAnchorConstraint >> update [

	self createUpdater update
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> useGuideLine [

	self guideLine color: Color veryVeryLightGray
]
