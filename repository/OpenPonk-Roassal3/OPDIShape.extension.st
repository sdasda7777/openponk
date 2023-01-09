Extension { #name : #OPDIShape }

{ #category : #'*OpenPonk-Roassal3' }
OPDIShape >> boundsFromRSShape: aRSBoundingShape [

	self bounds: (OPDIBounds
			 withPosition: aRSBoundingShape position
			 extent: aRSBoundingShape extent)
]

{ #category : #'*OpenPonk-Roassal3' }
OPDIShape >> layoutRSShape: aRSBoundingShape [

	aRSBoundingShape
		extent: self bounds extent;
		translateTo: self bounds position
]
