Class {
	#name : #OPDILabel,
	#superclass : #OPDIShape,
	#instVars : [
		'text'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #rendering }
OPDILabel >> renderBasicShape [

	^ RSLabel new
		  fontSize: self fontSize;
		  fontName: self fontName;
		  color: self fontColor;
		  text: self text;
		  emphasis: self emphasis;
		  model: self;
		  yourself
]
