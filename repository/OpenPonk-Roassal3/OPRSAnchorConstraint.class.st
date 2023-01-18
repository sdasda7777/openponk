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
	self guideLine
		from: shape;
		to: self anchorShape.
	shape canvas add: self guideLine.
	self lineMoved.
	shape signalUpdate
]

{ #category : #building }
OPRSAnchorConstraint >> anchorShape [

	anchorShape ifNotNil: [ ^ anchorShape ].
	anchorShape := RSBox new.
	anchorShape
		size: 1;
		color: Color transparent.
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
	line from when: RSPositionChangedEvent do: [ self lineMoved ].
	line to when: RSPositionChangedEvent do: [ self lineMoved ].
	shape when: RSMouseLeftDragStart do: [ self addAnchorAndGuideLine ].
	shape when: RSMouseDragging  do: [ self shapeMoved ].
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
	^ guideLine
]

{ #category : #building }
OPRSAnchorConstraint >> initialize [

	super initialize.
	self useGuideLine
]

{ #category : #accessing }
OPRSAnchorConstraint >> line [
	^ line
]

{ #category : #updating }
OPRSAnchorConstraint >> lineMoved [

	self createUpdater update
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
	guideLine ifNotNil: [ guideLine remove ].
	shape signalUpdate
]

{ #category : #accessing }
OPRSAnchorConstraint >> shape [
	^ shape
]

{ #category : #updating }
OPRSAnchorConstraint >> shapeMoved [

	| nearestPointInfo |
	nearestPointInfo := self createUpdater nearestPointInfo.
	balance := nearestPointInfo balance.
	minDistance := nearestPointInfo distanceTo: shape position.
	self createUpdater moveAnchor
]

{ #category : #building }
OPRSAnchorConstraint >> stick: aShape on: aLine [

	shape := aShape.
	line := aLine.
	self build
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> useGuideLine [

	self guideLine color: (Color gray: 0.9)
]
