Extension { #name : #RSShape }

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> asEmptyMarker [

	self color: Color white.
	^ OPRSEmptyMarker new shape: self
]

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> isElement [

	self
		deprecated: 'Use isNode instead.'
		transformWith: '`@receiver isElement' -> '`@receiver isNode'.
	^ self isNode
]

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> view [

	self
		deprecated: 'Use canvas instead.'
		transformWith: '`@receiver view' -> '`@receiver canvas'.
	^ self canvas
]
