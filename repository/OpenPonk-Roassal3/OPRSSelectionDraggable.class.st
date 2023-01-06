Class {
	#name : #OPRSSelectionDraggable,
	#superclass : #RSDraggable,
	#category : #'OpenPonk-Roassal3'
}

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> wantsUniqueInstance [

	^ false
]

{ #category : #hooks }
OPRSSelectionDraggable >> onShape: aShape [

	super onShape: aShape.
	aShape propertyAt: self class put: self
]

{ #category : #events }
OPRSSelectionDraggable >> processDrag: evt [

	| d selectedShapes shapesToMove |
	d := evt camera distanceFromPixelToSpace: evt step.
	selectedShapes := (evt canvas
		                   propertyAt: #selected_shapes
		                   ifAbsent: [ { evt shape } ]) ifEmpty: [ 
		                  { evt shape } ].
	shapesToMove := (selectedShapes includes: evt shape)
		                ifTrue: [ 
			                selectedShapes select: [ :each | 
				                each hasProperty: self class ] ]
		                ifFalse: [ { evt shape } ].
	shapesToMove do: [ :each | each translateBy: d ].
	evt signalUpdate
]
