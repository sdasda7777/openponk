Class {
	#name : #OPRSInteractiveLine,
	#superclass : #Object,
	#instVars : [
		'source',
		'mouseBox',
		'line',
		'running',
		'lineBuilder',
		'moveSubscription',
		'canvas'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #accessing }
OPRSInteractiveLine >> from: aShape [
	source := aShape
]

{ #category : #initialization }
OPRSInteractiveLine >> initialize [
	super initialize.
	running := false
]

{ #category : #accessing }
OPRSInteractiveLine >> lineBuilder: aBlock [
	lineBuilder := aBlock
]

{ #category : #accessing }
OPRSInteractiveLine >> remove [

	running ifFalse: [ ^ self ].
	running := false.
	canvas announcer unsubscribe: moveSubscription.
	mouseBox remove.
	canvas signalUpdate
]

{ #category : #hooks }
OPRSInteractiveLine >> renderIn: aCanvas [

	canvas := aCanvas.

	mouseBox := (RSBox model: self)
		            size: 2;
		            color: Color transparent;
		            yourself.

	line := lineBuilder value: source value: mouseBox.
	line model: self.

	mouseBox translateTo: source position.

	aCanvas add: mouseBox.
	aCanvas add: line.

	aCanvas signalUpdate.

	moveSubscription := aCanvas
		                    when: RSMouseMove
		                    do: [ :event | 
		                    mouseBox translateTo: event position ].

	running := true
]
