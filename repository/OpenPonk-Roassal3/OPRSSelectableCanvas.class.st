Class {
	#name : #OPRSSelectableCanvas,
	#superclass : #RSElasticBoxInteraction,
	#instVars : [
		'multiselectEnabled'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #'event processing' }
OPRSSelectableCanvas >> boxEnded: event [

	multiselectEnabled ifFalse: [ ^ self ].
	^ super boxEnded: event
]

{ #category : #'event processing' }
OPRSSelectableCanvas >> boxStarted: event [

	multiselectEnabled ifFalse: [ ^ self ].
	^ super boxStarted: event
]

{ #category : #'event processing' }
OPRSSelectableCanvas >> boxUpdated: event [

	multiselectEnabled ifFalse: [ ^ self ].
	^ super boxUpdated: event
]

{ #category : #accessing }
OPRSSelectableCanvas >> color [
	^ Color black alpha: 0.2
]

{ #category : #accessing }
OPRSSelectableCanvas >> defaultBox [

	^ super defaultBox
		  color: (Color black alpha: 0.2);
		  yourself
]

{ #category : #protocol }
OPRSSelectableCanvas >> disableMultiselect [

	multiselectEnabled := false
]

{ #category : #protocol }
OPRSSelectableCanvas >> enableMultiselect [

	multiselectEnabled := true
]

{ #category : #initialization }
OPRSSelectableCanvas >> initialize [

	super initialize.
	selectedShapes := RSGroup new.
	self
		targetShapes: [:x | self halt ];
		enableMultiselect
]

{ #category : #hooks }
OPRSSelectableCanvas >> onShape: aCanvas [

	super onShape: aCanvas.
	aCanvas propertyAt: self class put: self.
	aCanvas
		when: RSMouseLeftClick
		do: [ :evt | self selectShapes: RSGroup new byEvent: evt ]
]

{ #category : #hooks }
OPRSSelectableCanvas >> selectShapes: aGroup byEvent: anEvent [

	(multiselectEnabled not and: [ aGroup size > 1 ]) ifTrue: [ ^ self ].
	selectedShapes := aGroup.
	{ 
		RSSelectionStartEvent.
		RSSelectionChangedEvent.
		RSSelectionEndEvent }
		collect: [ :each | 
			(self createEvent: each with: anEvent) selectedShapes:
				selectedShapes ]
		thenDo: [ :each | self announce: each ]
]
