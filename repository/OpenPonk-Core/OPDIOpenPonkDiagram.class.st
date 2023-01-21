Class {
	#name : #OPDIOpenPonkDiagram,
	#superclass : #OPDIDiagram,
	#instVars : [
		'isOpen',
		'order',
		'isSelected',
		'camera'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPDIOpenPonkDiagram >> camera: aCamera [

	camera := OPDICamera newFrom: aCamera
]

{ #category : #accessing }
OPDIOpenPonkDiagram >> isOpen [

	^ isOpen ifNil: [ true ]
]

{ #category : #accessing }
OPDIOpenPonkDiagram >> isOpen: anObject [

	isOpen := anObject
]

{ #category : #accessing }
OPDIOpenPonkDiagram >> isSelected [

	^ isSelected ifNil: [ false ]
]

{ #category : #accessing }
OPDIOpenPonkDiagram >> isSelected: anObject [

	isSelected := anObject
]

{ #category : #removing }
OPDIOpenPonkDiagram >> removeRender [

	self ownedElements do: #removeRender.
	roassalShape := nil
]

{ #category : #'as yet unclassified' }
OPDIOpenPonkDiagram >> updateFromRender [

	super updateFromRender.
	self camera: roassalShape camera
]

{ #category : #'as yet unclassified' }
OPDIOpenPonkDiagram >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	super updateRenderFromSelf.
	camera ifNil: [ ^ self ].
	camera updateRoassalCamera: roassalShape camera
]
