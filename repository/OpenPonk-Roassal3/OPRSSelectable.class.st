Class {
	#name : #OPRSSelectable,
	#superclass : #RSHighlightable,
	#category : #'OpenPonk-Roassal3'
}

{ #category : #'as yet unclassified' }
OPRSSelectable >> highlightBorderColor: aColor [

	"Set the border color"

	self
		when: RSHighlightEvent
		do: [ :evt | 
			self record: evt shape selector: #borderColor value: aColor ];
		when: RSUnHighlightEvent
		do: [ :evt | self restore: evt shape selector: #borderColor ]
]

{ #category : #hooks }
OPRSSelectable >> onShape: aShape [

	aShape propertyAt: self class put: self.
	aShape when: RSMouseLeftClick do: [ :evt | 
		aShape canvas
			propertyAt: OPRSSelectableCanvas
			ifPresent: [ :selectableCanvasInteraction | 
				selectableCanvasInteraction
					selectShapes: (RSGroup streamContents: [ :s | 
							 evt metaKeyPressed ifTrue: [ 
								 s nextPutAll: selectableCanvasInteraction selectedShapes ].
							 s nextPut: aShape ])
					byEvent: evt ]
			ifAbsent: [ 
				self error:
					'OPRSSelectable requires OPRSSelectableCanvas on canvas' ] ]
]
