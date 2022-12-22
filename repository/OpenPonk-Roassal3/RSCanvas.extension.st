Extension { #name : #RSCanvas }

{ #category : #'*OpenPonk-Roassal3' }
RSCanvas >> canvas [

	self
		deprecated: 'I am the canvas.'
		transformWith: '`@receiver canvas' -> '`@receiver'.
	^ self
]

{ #category : #'*OpenPonk-Roassal3' }
RSCanvas >> elements [

	self
		deprecated: 'Use #nodes instead.'
		transformWith: '`@receiver elements' -> '`@receiver nodes'.
	^ self nodes
]
