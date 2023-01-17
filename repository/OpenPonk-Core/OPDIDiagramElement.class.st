Class {
	#name : #OPDIDiagramElement,
	#superclass : #Object,
	#instVars : [
		'modelElements',
		'owningElement',
		'targetEdges',
		'sourceEdges',
		'sharedStyle',
		'localStyle',
		'ownedElements',
		'roassalShape',
		'canvas'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #rendering }
OPDIDiagramElement class >> forModelElement: anObject [

	^ self new
		  modelElement: anObject;
		  yourself
]

{ #category : #rendering }
OPDIDiagramElement class >> in: anOwner forModelElement: anObject [

	^ self new
		  modelElement: anObject;
		  owningElement: anOwner;
		  yourself
]

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

{ #category : #'ston-core' }
OPDIDiagramElement class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames copyWithoutAll:
		  #( #roassalShape #canvas )
]

{ #category : #accessing }
OPDIDiagramElement >> canvas [

	^ canvas
]

{ #category : #'instance creation' }
OPDIDiagramElement >> fromSton: stonReader [

	stonReader parseMapDo: [ :instVarName :value | 
		instVarName = #modelElements
			ifTrue: [ 
				self modelElements: (value collect: [ :each | 
						 OPModelObjectReference withUUID: ([ UUID fromString: each ]
								  on: Error
								  do: [ each ]) ]) ]
			ifFalse: [ self instVarNamed: instVarName asString put: value ] ]
]

{ #category : #initialization }
OPDIDiagramElement >> initialize [

	super initialize.
	modelElements := #(  ).
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

{ #category : #rendering }
OPDIDiagramElement >> isRendered [

	^ roassalShape isNotNil and: [ roassalShape isInACanvas ]
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

	anObject ifNil: [ ^ self modelElements: #(  ) ].
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

{ #category : #'as yet unclassified' }
OPDIDiagramElement >> ownedElementRenderedIn: aCanvas [

	canvas ifNil: [ ^ canvas := aCanvas ].
	canvas = aCanvas ifFalse: [ 
		self error:
			'Reusing same diagram element for 2 canvases not allowed' ]
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

	self ownedElements do: #removeRender.
	roassalShape ifNil: [ ^ self ].
	roassalShape remove.
	roassalShape := nil
]

{ #category : #rendering }
OPDIDiagramElement >> renderBasicShape [

	"should render a simple shape without any interactivity and complexity (for example for outlining the shape when being created before it is fully added)"

	^ self subclassResponsibility
]

{ #category : #rendering }
OPDIDiagramElement >> renderBasicShapeIn: aCanvas [

	canvas ifNotNil: [ 
		canvas = aCanvas ifFalse: [ 
			self error:
				'Reusing same diagram element for 2 canvases not allowed' ].
		self isRendered ifTrue: [ ^ self ] ].
	canvas := aCanvas.
	self renderBasicShape.
	^ roassalShape
]

{ #category : #rendering }
OPDIDiagramElement >> renderIn: aCanvas [

	self renderBasicShapeIn: aCanvas.
	self renderShapeDetails.
	self updateRenderFromModel.
	self updateRenderFromSelf.
	self ownedElements do: [ :each | each renderIn: aCanvas ].
	self owningElement ifNotNil: [ :element | 
		element ownedElementRenderedIn: self canvas ].
	^ roassalShape
]

{ #category : #rendering }
OPDIDiagramElement >> renderShapeDetails [

	"should render details of a shape created by renderBasicShape ... this method is there to add interactivity and complexity like adding labels, actions on click etc."

	"do nothing by default"

	
]

{ #category : #serialization }
OPDIDiagramElement >> resolveAllModelElements: aDictionary [

	self resolveModelElements: aDictionary.
	self ownedElements do: [ :each | 
		each resolveAllModelElements: aDictionary ]
]

{ #category : #serialization }
OPDIDiagramElement >> resolveModelElements: aDictionary [

	self modelElements: (self modelElements collect: [ :each | 
			 each modelObjectFrom: aDictionary ])
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

{ #category : #'ston persistence' }
OPDIDiagramElement >> stonOn: stonWriter [

	stonWriter writeObject: self streamMap: [ :dictionary | 
		self class stonAllInstVarNames do: [ :each | 
			| value |
			value := self instVarNamed: each.
			each = #modelElements ifTrue: [ 
				value := modelElements collect: [ :eachModelElement | 
					         eachModelElement uuid asString ] ].
			(value isKindOf: SRToManyLink) ifTrue: [ 
				value := value species newFrom: value ].
			value ifNotNil: [ dictionary at: each asSymbol put: value ] ] ]
]

{ #category : #initialization }
OPDIDiagramElement >> stonPostReferenceResolution [

	"Hook that is called when references were resolved processing this object or one of its sub objects. This will most probably influence hash values. Override to take appropriate action."

	ownedElements := (SRToManyLink
		                  on: self
		                  slot: #ownedElements
		                  oppositeSlot: #owningElement)
		                 addAll: ownedElements;
		                 yourself.
	sourceEdges := (SRToManyLink
		                on: self
		                slot: #sourceEdges
		                oppositeSlot: #source)
		               addAll: sourceEdges;
		               yourself.
	targetEdges := (SRToManyLink
		                on: self
		                slot: #targetEdges
		                oppositeSlot: #target)
		               addAll: targetEdges;
		               yourself
]

{ #category : #'instance creation' }
OPDIDiagramElement >> stonProcessSubObjects: block [

	"Execute block to (potentially) change each of my subObjects.
	In general, all instance and indexable variables are processed.
	Overwrite when necessary. Not used when #stonContainSubObjects returns false."

	self class stonAllInstVarNames do: [ :each | 
		self
			instVarNamed: each
			put: (block value: (self instVarNamed: each)) ]
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

	self ownedElements do: #updateFromRender
]

{ #category : #rendering }
OPDIDiagramElement >> updateRenderFromModel [

	self ownedElements do: #updateRenderFromModel
]

{ #category : #rendering }
OPDIDiagramElement >> updateRenderFromSelf [

	self ownedElements do: #updateRenderFromSelf
]
