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

	^ self
		  stylePropertyNamed: #fontEmphasis
		  ifAbsent: [ self defaultEmphasis ]
]

{ #category : #accessing }
OPDILabel >> fontColor [

	^ self
		  stylePropertyNamed: #fontColor
		  ifAbsent: [ self defaultFontColor ]
]

{ #category : #accessing }
OPDILabel >> fontName [

	^ self
		  stylePropertyNamed: #fontName
		  ifAbsent: [ self defaultFontName ]
]

{ #category : #accessing }
OPDILabel >> fontSize [

	^ self
		  stylePropertyNamed: #fontSize
		  ifAbsent: [ self defaultFontSize ]
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
