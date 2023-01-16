Class {
	#name : #OPXmiDiagramSerializer,
	#superclass : #OPDiagramSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPXmiDiagramSerializer >> formatName [
	^ 'xmi'
]

{ #category : #'serialize/materialize' }
OPXmiDiagramSerializer >> materializeDiagramOf: aModel from: aStream [

	"materialize aStream into a diagram that will be consumed by your controller"

	(OPUMLXMIReader read: aStream) inspect.
	^ OPDiagram ofModel: aModel fromJson: aStream
]

{ #category : #'serialize/materialize' }
OPXmiDiagramSerializer >> serializeDiagram: aDiagram to: aStream [

	"Serialize a diagram returned by your controller to a string"

	^ OPUMLXMIWriter write: aDiagram toStream: aStream
]
