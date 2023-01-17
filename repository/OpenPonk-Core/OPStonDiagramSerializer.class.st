Class {
	#name : #OPStonDiagramSerializer,
	#superclass : #OPDiagramSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPStonDiagramSerializer >> formatName [
	^ 'ston'
]

{ #category : #'serialize/materialize' }
OPStonDiagramSerializer >> materializeDiagramOf: aModel from: aStream [

	| diagram adapters allModelElements |
	diagram := STON fromStream: aStream.
	adapters := OPNavigatorAdapters new.
	allModelElements := ((Set with: aModel)
	                     , (adapters allChildrenFor: aModel) collect: [ 
		                     :each | each uuid -> each ]) asDictionary.
	diagram resolveAllModelElements: allModelElements.
	^ diagram
]

{ #category : #'ston - serialize/materialize' }
OPStonDiagramSerializer >> serialize: anObject [
	^ STON toStringPretty: anObject
]

{ #category : #'serialize/materialize' }
OPStonDiagramSerializer >> serializeDiagram: aDiagramMemento [
	^ self serialize: aDiagramMemento
]
