Class {
	#name : #OPMementoSerializer,
	#superclass : #OPSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'as yet unclassified' }
OPMementoSerializer class >> exportSubject [

	^ #modelWithDiagrams
]

{ #category : #adding }
OPMementoSerializer >> addFormatNameTo: aFileReference [
	^ aFileReference
]
