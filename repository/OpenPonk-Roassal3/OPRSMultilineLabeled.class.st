Class {
	#name : #OPRSMultilineLabeled,
	#superclass : #RSLabeled,
	#category : #'OpenPonk-Roassal3'
}

{ #category : #initialization }
OPRSMultilineLabeled >> initialize [ 
	super initialize.
	self halt.
	self shapeBuilder wrapStrategy: (RSWrapStrategy new wrapMaxWidth: 200).
]
