Class {
	#name : #OPDIDiagramElement,
	#superclass : #Object,
	#instVars : [
		'sharedStyle',
		'localStyle',
		'ownedElements',
		'owningElement',
		'modelElements',
		'targetEdges',
		'sourceEdges'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #testing }
OPDIDiagramElement class >> isAbstract [
	^ self = OPDIDiagramElement
]

{ #category : #initialization }
OPDIDiagramElement >> initialize [

	super initialize.
	ownedElements := SRToManyLink
		                 on: self
		                 slot: #ownedElements
		                 oppositeSlot: #owningElement.
	sourceEdges := SRToManyLink
		               on: self
		               slot: #sourceEdges
		               oppositeSlot: #source.
	targetEdges := SRToManyLink
		               on: self
		               slot: #targetEdges
		               oppositeSlot: #target
]

{ #category : #accessing }
OPDIDiagramElement >> localStyle [
	^ localStyle
]

{ #category : #accessing }
OPDIDiagramElement >> localStyle: aStyle [

	localStyle ifNotNil: [ localStyle removedFromStyledElement: self ].
	(localStyle := aStyle) addedAsLocalToStyledElement: self
]

{ #category : #accessing }
OPDIDiagramElement >> modelElements [

	^ modelElements
]

{ #category : #accessing }
OPDIDiagramElement >> modelElements: anObject [

	modelElements := anObject
]

{ #category : #accessing }
OPDIDiagramElement >> ownedElements [
	^ ownedElements
]

{ #category : #accessing }
OPDIDiagramElement >> ownedElements: aCollection [

	ownedElements
		removeAll;
		addAll: aCollection
]

{ #category : #accessing }
OPDIDiagramElement >> owningElement [
	^ owningElement
]

{ #category : #accessing }
OPDIDiagramElement >> owningElement: aDiagramElement [
	owningElement := SRToOneLink
		on: self
		slot: #owningElement
		oppositeSlot: #ownedElements
		updateFrom: owningElement
		to: aDiagramElement
]

{ #category : #removing }
OPDIDiagramElement >> remove [
	self subclassResponsibility
]

{ #category : #accessing }
OPDIDiagramElement >> sharedStyle [
	^ sharedStyle ifNil: [ self owningElement ifNotNil: #sharedStyle ]
]

{ #category : #accessing }
OPDIDiagramElement >> sharedStyle: aStyle [

	sharedStyle ifNotNil: [ sharedStyle removedFromStyledElement: self ].
	(sharedStyle := aStyle) addedAsSharedToStyledElement: self
]

{ #category : #accessing }
OPDIDiagramElement >> sourceEdges [
	^ sourceEdges
]

{ #category : #accessing }
OPDIDiagramElement >> sourceEdges: aCollection [
	sourceEdges
		removeAll;
		addAll: aCollection
]

{ #category : #accessing }
OPDIDiagramElement >> style [
	^ self localStyle ifNil: [ self sharedStyle ]
]

{ #category : #accessing }
OPDIDiagramElement >> targetEdges [
	^ targetEdges
]

{ #category : #accessing }
OPDIDiagramElement >> targetEdges: aCollection [
	targetEdges
		removeAll;
		addAll: aCollection
]
