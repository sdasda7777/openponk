Class {
	#name : #OPRSEventLogger,
	#superclass : #RSAbstractCanvasInteraction,
	#instVars : [
		'loggedEvents',
		'onlyLastOne'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #hooks }
OPRSEventLogger >> allOf: eachClass [

	^ (loggedEvents at: eachClass ifAbsent: OrderedCollection new)
		  asOrderedCollection
]

{ #category : #initialization }
OPRSEventLogger >> initialize [

	onlyLastOne := true.
	loggedEvents := Dictionary new
]

{ #category : #'as yet unclassified' }
OPRSEventLogger >> keepWholeHistory [

	onlyLastOne := false
]

{ #category : #hooks }
OPRSEventLogger >> lastOf: eachClass [

	^ [ (self allOf: eachClass) last ]
		  on: SubscriptOutOfBounds
		  do: [ nil ]
]

{ #category : #hooks }
OPRSEventLogger >> logEvent: aRSEvent [

	(aRSEvent class withAllSuperclasses copyUpThrough: RSEvent) do: [ 
		:eachClass | self logEvent: aRSEvent as: eachClass ]
]

{ #category : #hooks }
OPRSEventLogger >> logEvent: aRSEvent as: eachClass [

	onlyLastOne ifTrue: [ ^ loggedEvents at: eachClass put: aRSEvent ].

	(loggedEvents at: eachClass ifAbsentPut: OrderedCollection new) add:
		aRSEvent
]

{ #category : #hooks }
OPRSEventLogger >> onShape: aShapeOrCanvas [

	aShapeOrCanvas
		when: RSEvent
		do: [ :e | self logEvent: e ].
	aShapeOrCanvas propertyAt: self class put: self
]
