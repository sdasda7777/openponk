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

	anchorShape := RSBox new.
	anchorShape
		size: 0;
		color: Color red.
	shape canvas add: anchorShape.
	guideLine := RSLine new.
	guideLine
		color: Color transparent;
		from: shape to: anchorShape.
	shape canvas add: guideLine.
	line when: RSShapeRemovedEvent do: [ self remove ]
]

{ #category : #building }
OPRSAnchorConstraint >> anchorSegment [
	^ self segments segmentWithPointFor: self balance
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

	self addAnchorAndGuideLine.
	line from when: RSPositionChangedEvent do: [ self update ].
	line to when: RSPositionChangedEvent do: [ self update ].
	shape when: RSMouseLeftDragStart do: [ guideLine color: Color gray ].
	shape when: RSMouseDragEnd do: [ guideLine color: Color transparent ]
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> computeExtraDistance [

	"Compute the extra distance required to move the element to not overlap the segment."

	| segment sideOfElement normals |
	segment := self anchorSegment first.
	sideOfElement := segment sideOfPoint: shape position.
	normals := shape encompassingRectangle corners
		           select: [ :each | 
		           (segment sideOfPoint: each) ~= sideOfElement ]
		           thenCollect: [ :each | 
			           each distanceTo:
				           (each
					            nearestPointAlongLineFrom: segment from
					            to: segment to) ].
	normals ifEmpty: [ ^ 0 ].
	^ minDistance sign > 0
		  ifTrue: [ normals max ]
		  ifFalse: [ normals max negated ]
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> connectionSegmentsFor: anEdge [
	^ (anEdge shape pathFor: anEdge)
		overlappingPairsCollect: [ :from :to | RTLineSegment from: from to: to ]
]

{ #category : #accessing }
OPRSAnchorConstraint >> element [
	^ shape
]

{ #category : #accessing }
OPRSAnchorConstraint >> element: anElement [
	shape := anElement
]

{ #category : #accessing }
OPRSAnchorConstraint >> line [
	^ line
]

{ #category : #accessing }
OPRSAnchorConstraint >> line: aLine [
	line := aLine
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> lineSegmentFor: anEdge [
	^ anEdge lineSegments first
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
OPRSAnchorConstraint >> moveAnchor [
	anchorShape translateTo: self anchorSegment last
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> moveAwayFrom: aRectangle via: aVector [

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
		            sg := RTLineSegment from: each to: each + vector.
		            RTLineSegment
			            from: each
			            to: (sg intersectRectangle: aRectangle) anyOne ]) 
		           detectMax: #length.
	segment ifNotNil: [ shape translateBy: segment vector ]
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> moveAwayFromSegment: aSegment [
	(aSegment intersectRectangle: shape encompassingRectangle)
		ifNotEmpty:
			[ :crossings | 
			shape
				translateBy:
					aSegment vector normal
						* (minDistance + self computeExtraDistance) negated ]
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> moveElement [
	| segment from to |
	segment := self anchorSegment first.
	shape
		translateTo: anchorShape position + (segment vector normal * minDistance negated).
	self moveAwayFromSegment: segment.
	from := line from encompassingRectangle expandBy: minDistance abs.
	to := line to encompassingRectangle expandBy: minDistance abs.
	balance > 0 & (shape encompassingRectangle intersects: from)
		ifTrue: [ self moveAwayFrom: from via: segment vector ].
	balance < 0 & (shape encompassingRectangle intersects: to)
		ifTrue: [ self moveAwayFrom: to via: segment vector negated ]
]

{ #category : #building }
OPRSAnchorConstraint >> remove [

	shape remove.
	anchorShape remove.
	guideLine remove
]

{ #category : #accessing }
OPRSAnchorConstraint >> segments [

	^ self connectionSegmentsFor: line
]

{ #category : #updating }
OPRSAnchorConstraint >> update [
	self moveAnchor.
	self moveElement
]
