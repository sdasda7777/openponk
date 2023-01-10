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
		'sourceEdges',
		'roassalShape',
		'canvas'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #testing }
OPDIDiagramElement class >> isAbstract [
	^ self = OPDIDiagramElement
]

{ #category : #rendering }
OPDIDiagramElement class >> renderForController: aController [

	^ self new
		  modelElement: aController model;
		  renderIn: aController diagramController canvas;
		  yourself
]

{ #category : #accessing }
OPDIDiagramElement >> canvas [

	^ canvas
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

{ #category : #testing }
OPDIDiagramElement >> isSelectable [

	^ roassalShape isSelectable
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
OPDIDiagramElement >> model [

	self
		deprecated: 'Use #modelElement instead'
		transformWith: '`@receiver model' -> '`@receiver modelElement'.
	^ self modelElement
]

{ #category : #accessing }
OPDIDiagramElement >> modelElement [

	^ modelElements first
]

{ #category : #accessing }
OPDIDiagramElement >> modelElement: anObject [

	self modelElements: { anObject }
]

{ #category : #accessing }
OPDIDiagramElement >> modelElements [

	^ modelElements
]

{ #category : #accessing }
OPDIDiagramElement >> modelElements: aCollection [

	modelElements := aCollection
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

	self
		deprecated: 'Use #removeRender instead.'
		transformWith: '`@receiver remove' -> '`@receiver removeRender'.
	^ self removeRender
]

{ #category : #removing }
OPDIDiagramElement >> removeRender [

	roassalShape remove
]

{ #category : #rendering }
OPDIDiagramElement >> render [

	^ self subclassResponsibility
]

{ #category : #rendering }
OPDIDiagramElement >> renderIn: aCanvas [

	canvas := aCanvas.
	self render.
	self updateRenderFromModel.
	self updateRenderFromSelf.
	^ roassalShape
]

{ #category : #rendering }
OPDIDiagramElement >> roassalShape [

	^ roassalShape
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

{ #category : #'as yet unclassified' }
OPDIDiagramElement >> updateFromRender [

	"do nothing here"
]

{ #category : #rendering }
OPDIDiagramElement >> updateRenderFromModel [

	"do nothing by default"
]

{ #category : #rendering }
OPDIDiagramElement >> updateRenderFromSelf [

	"do nothing by default"
]
