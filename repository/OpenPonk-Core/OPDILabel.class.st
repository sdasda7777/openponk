Class {
	#name : #OPDILabel,
	#superclass : #OPDIShape,
	#instVars : [
		'text'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPDILabel >> defaultEmphasis [

	^ TextEmphasis normal
]

{ #category : #accessing }
OPDILabel >> defaultFontColor [

	^ Color black
]

{ #category : #accessing }
OPDILabel >> defaultFontName [

	^ RSLabel defaultFont familyName
]

{ #category : #accessing }
OPDILabel >> defaultFontSize [

	^ 10
]

{ #category : #accessing }
OPDILabel >> emphasis [

	^ self style
		  ifNil: [ self defaultEmphasis ]
		  ifNotNil: [ :style | style emphasis ]
]

{ #category : #accessing }
OPDILabel >> fontColor [

	^ self style
		  ifNil: [ self defaultFontColor ]
		  ifNotNil: [ :style | style fontColor ]
]

{ #category : #accessing }
OPDILabel >> fontName [

	^ self style
		  ifNil: [ self defaultFontName ]
		  ifNotNil: [ :style | style fontName ]
]

{ #category : #accessing }
OPDILabel >> fontSize [

	^ self style
		  ifNil: [ self defaultFontSize ]
		  ifNotNil: [ :style | style fontSize ]
]

{ #category : #rendering }
OPDILabel >> renderBasicShape [

	roassalShape := RSLabel new.
	roassalShape
		fontSize: self fontSize;
		fontName: self fontName;
		color: self fontColor;
		text: self text;
		emphasis: self emphasis;
		model: self;
		yourself.
	canvas add: roassalShape
]

{ #category : #accessing }
OPDILabel >> text [

	^ self subclassResponsibility
]
