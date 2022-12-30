Extension { #name : #RSCanvas }

{ #category : #'*OpenPonk-Roassal3' }
RSCanvas >> elements [

	self
		deprecated: 'Use #nodes instead.'
		transformWith: '`@receiver elements' -> '`@receiver nodes'.
	^ self nodes
]

{ #category : #'*OpenPonk-Roassal3' }
RSCanvas >> view [

	self
		deprecated: 'I am the view.'
		transformWith: '`@receiver view' -> '`@receiver'.
	^ self
]
