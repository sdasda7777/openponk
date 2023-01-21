Class {
	#name : #OPSerializer,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'as yet unclassified' }
OPSerializer class >> exportInfo [

	^ OPExportInfo new
		  subject: self exportSubject;
		  version: self exportVersion;
		  format: self formatName
]

{ #category : #'as yet unclassified' }
OPSerializer class >> exportSubject [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPSerializer class >> exportVersion [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPSerializer class >> forExportInfo: anExportInfo [

	| possibleClasses |
	possibleClasses := self allSubclasses select: [ :each | 
		                   each supportsExportInfo: anExportInfo ].
	possibleClasses ifEmpty: [ 
		^ 'This export format/version is not supported' ].
	(possibleClasses sorted: [ :a :b | 
		 a maxImportVersion = b maxImportVersion
			 ifTrue: [ a minImportVersion > b minImportVersion ]
			 ifFalse: [ a maxImportVersion > b maxImportVersion ] ]) first
]

{ #category : #'as yet unclassified' }
OPSerializer class >> formatName [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPSerializer class >> maxImportVersion [

	^ self exportVersion
]

{ #category : #'as yet unclassified' }
OPSerializer class >> minImportVersion [

	^ self subclassResponsibility
]

{ #category : #accessing }
OPSerializer class >> supportsExportInfo: anExportInfo [

	^ [ 
	  anExportInfo subject = self exportSubject and: [ 
		  anExportInfo formatName = self formatName and: [ 
			  anExportInfo version
				  between: self minImportVersion
				  and: self maxImportVersion ] ] ]
		  on: SubclassResponsibility
		  do: [ false ]
]
