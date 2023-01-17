Class {
	#name : #OPDINoShape,
	#superclass : #OPDIShape,
	#instVars : [
		'moveSubscription'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #rendering }
OPDINoShape class >> renderToPosition: aPoint onCanvas: aCanvas [

	^ self new
		  bounds: (OPDIBounds withPosition: aPoint extent: 2 @ 2);
		  renderIn: aCanvas;
		  yourself
]

{ #category : #rendering }
OPDINoShape >> removeRender [

	canvas announcer unsubscribe: self.
	super removeRender
]

{ #category : #rendering }
OPDINoShape >> renderBasicShape [

	roassalShape := RSBox new
		                color: Color transparent;
		                borderColor: Color transparent;
		                yourself.

	moveSubscription := canvas when: RSMouseMove do: [ :event | 
		                    roassalShape
			                    translateTo: event position;
			                    signalUpdate ].

	canvas add: roassalShape
]
