Class {
	#name : #OPRSAnchorConstraintUpdater,
	#superclass : #RSObject,
	#instVars : [
		'line',
		'balance',
		'minDistance',
		'anchorShape',
		'shape',
		'absoluteBalance',
		'segments',
		'anchorSegment',
		'anchorPoint',
		'extraDistance'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #building }
OPRSAnchorConstraintUpdater >> absoluteBalance [

	^ absoluteBalance ifNil: [ 
		  absoluteBalance := self computeAbsoluteBalance ]
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> anchorPoint [

	anchorPoint ifNil: [ self computeAnchorSegmentAndPoint ].
	^ anchorPoint
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> anchorSegment [

	anchorSegment ifNil: [ self computeAnchorSegmentAndPoint ].
	^ anchorSegment
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> anchorShape: aShape [

	anchorShape := aShape
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> balance [
	^ balance
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> balance: aNumber [
	balance := aNumber
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> computeAbsoluteBalance [

	| lineLength |
	lineLength := self segments sumNumbers: [ :segment | segment length ].
	balance > 1 ifTrue: [ ^ lineLength min: balance ].
	balance < 0 ifTrue: [ ^ 0 max: lineLength - balance negated ].
	^ lineLength * balance
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> computeAnchorSegmentAndPoint [

	| sum newSum |
	sum := 0.
	self segments do: [ :each | 
		newSum := sum + each length.
		(self absoluteBalance between: sum and: newSum) ifTrue: [ 
			anchorSegment := each.
			anchorPoint := each pointForBalance: self absoluteBalance - sum.
			^ self ].
		sum := newSum ].
	self error: 'failed to find a segment'
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintUpdater >> computeExtraDistance [

	"Compute the extra distance required to move the element to not overlap the segment."

	| sideOfElement normals |
	sideOfElement := self anchorSegment sideOfPoint: shape position.
	normals := shape encompassingRectangle corners
		           select: [ :each | 
		           (self anchorSegment sideOfPoint: each) ~= sideOfElement ]
		           thenCollect: [ :each | 
			           each distanceTo: (each
					            nearestPointAlongLineFrom: self anchorSegment from
					            to: self anchorSegment to) ].
	normals ifEmpty: [ ^ 0 ].
	^ minDistance sign > 0
		  ifTrue: [ normals max ]
		  ifFalse: [ normals max negated ]
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> extraDistance [

	^ extraDistance ifNil: [ extraDistance := self computeExtraDistance ]
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> line: aLine [

	line := aLine
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> minDistance [
	^ minDistance
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> minDistance: anInteger [
	minDistance := anInteger
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveAnchor [

	anchorShape ifNil: [ ^ self ].
	anchorShape translateTo: self anchorPoint
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveAwayFrom: aRectangle via: aVector [

	"There should be minDistance between the start and the element. Move it in the direction fo the current segment"

	| vector corners segment |
	"source and target of the edge on top of each other... ignore"
	aVector r = 0 ifTrue: [ ^ self ].
	vector := aVector normalized
	          * (aRectangle origin distanceTo: aRectangle corner).
	corners := shape encompassingRectangle corners select: [ :each | 
		           aRectangle containsPoint: each ].
	segment := (corners collect: [ :each | 
		            | sg |
		            sg := OPRSAnchorConstraintSegment
			                  from: each
			                  to: each + vector.
		            OPRSAnchorConstraintSegment
			            from: each
			            to: (sg intersectRectangle: aRectangle) anyOne ]) 
		           detectMax: #length.
	segment ifNotNil: [ shape translateBy: segment vector ]
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveAwayFromSegment: aSegment [
	(aSegment intersectRectangle: shape encompassingRectangle)
		ifNotEmpty:
			[ :crossings | 
			shape
				translateBy:
					aSegment vector normal
						* (minDistance + self extraDistance) negated ]
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveShape [

	| from to |
	shape translateTo: self anchorPoint
		+ (self anchorSegment vector normal * minDistance negated).
	self moveAwayFromSegment: self anchorSegment.
	from := line from encompassingRectangle expandBy: minDistance abs.
	to := line to encompassingRectangle expandBy: minDistance abs.
	balance > 0 & (shape encompassingRectangle intersects: from) ifTrue: [ 
		self moveAwayFrom: from via: self anchorSegment vector ].
	balance < 0 & (shape encompassingRectangle intersects: to) ifTrue: [ 
		self moveAwayFrom: to via: self anchorSegment vector negated ]
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> segments [

	^ segments ifNil: [ 
		  segments := line controlPoints overlappingPairsCollect: [ :a :b | 
			              OPRSAnchorConstraintSegment from: a to: b ] ]
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> shape: aShape [

	shape := aShape
]

{ #category : #updating }
OPRSAnchorConstraintUpdater >> update [

	self moveAnchor.
	self moveShape
]
