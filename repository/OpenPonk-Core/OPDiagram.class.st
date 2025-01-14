"
I represent a view of a model. The content of the model can be filtered, explicitly shown, or explicitly hidden.
Further I contain the layout of the entities in the view, and layout/configuration of the view itself.
"
Class {
	#name : #OPDiagram,
	#superclass : #Object,
	#instVars : [
		'name',
		'isOpen',
		'layout',
		'order',
		'isSelected',
		'camera',
		'visibleElements',
		'model',
		'commonElements'
	],
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #'instance creation' }
OPDiagram class >> emptyOfModel: aModel [
	^ self new
		name: aModel name;
		model: aModel;
		isOpen: false;
		isSelected: false;
		yourself
]

{ #category : #accessing }
OPDiagram class >> neoJsonMapping: mapper [

	mapper
		for: self do: [ :mapping | 
			mapping mapInstVars: mapping identifier instVarNames \ #( model ).
			(mapping mapInstVar: #layout) valueSchema: #UUIDsWithPoints.
			(mapping mapInstVar: #camera) valueSchema: OPDiagramCamera.
			(mapping mapInstVar: #commonElements) valueSchema: #CommonElements.
			(mapping mapInstVar: #visibleElements) valueSchema:
					#ObjectsWithUUIDs ];
		for: #CommonElements
		customDo: [ :mapping | mapping listOfElementSchema: #CommonElement ];
		for: #CommonElement customDo: [ :mapping | 
			mapping reader: [ :jsonReader | 
					| map element |
					map := jsonReader parseMap.
					element := (self class environment at:
							            (map at: #className) asSymbol) new.
					NeoJSONReader
						fromString: (NeoJSONWriter toString: map)
						as: element class ] ];
		for: #ObjectsWithUUIDs
		customDo: [ :mapping | mapping listOfElementSchema: #ObjectWithUUID ];
		for: #ObjectWithUUID customDo: [ :mapping | 
			mapping
				encoder: [ :object | object uuid asString ];
				decoder: [ :string | 
					OPModelObjectReference withUUID: ([ UUID fromString: string ]
								 on: Error
								 do: [ string ]) ] ];
		for: UUID customDo: [ :mapping | 
		mapping
			encoder: [ :uuid | uuid asString ];
			decoder: [ :string | 
				[ UUID fromString: string ]
					on: Error
					do: [ string ] ] ];
		for: #UUIDsWithPoints customDo: [ :mapping | 
		mapping
			reader: [ :jsonReader | 
				| map |
				map := jsonReader mapClass new.
				jsonReader parseMapKeysDo: [ :key | 
						| value |
						value := jsonReader nextAs: OPElementLayout.
						map
							at: ([ UUID fromString: key ]
									 on: Error
									 do: [ key ])
							put: value ].
				(map associations sorted: [ :a :b | a value < b value ])
					asOrderedDictionary ];
			writer: [ :jsonWriter :map | 
				jsonWriter writeMapStreamingDo: [ :mapWriter | 
						map keysAndValuesDo: [ :key :value | 
								mapWriter
									writeKey: key asString
									value: value
									as: OPElementLayout ] ] ] ]
]

{ #category : #'instance creation' }
OPDiagram class >> ofModel: aModel fromJson: aStream [
	^ ((NeoJSONReader on: aStream) nextAs: self)
		model: aModel;
		yourself
]

{ #category : #'instance creation' }
OPDiagram class >> ofModel: aModel fromJsonString: aString [
	^ self ofModel: aModel fromJson: aString readStream
]

{ #category : #'instance creation' }
OPDiagram class >> withWholeModel: aModel [
	^ (self emptyOfModel: aModel)
		setAllElementsVisible;
		yourself
]

{ #category : #copying }
OPDiagram >> = otherDiagram [
	^ self asJson = otherDiagram asJson
]

{ #category : #converting }
OPDiagram >> asInfo [
	self deprecated: 'OPDiagramInfo is no longer used'.
	
	^ OPDiagramInfo new
		diagramName: self name;
		isOpen: self isOpen;
		isSelected: self isSelected;
		order: self order;
		modelName: self modelName;
		modelType: self modelType;
		yourself
]

{ #category : #serializing }
OPDiagram >> asJson [

	^ String streamContents: [ :stream | self asJsonTo: stream ]
]

{ #category : #serializing }
OPDiagram >> asJsonTo: stream [
	^ (OPJsonWriter on: stream) nextPut: self
]

{ #category : #accessing }
OPDiagram >> camera [
	^ camera
]

{ #category : #accessing }
OPDiagram >> camera: aCameraSettings [
	camera := aCameraSettings
]

{ #category : #accessing }
OPDiagram >> commonElements [
	^ commonElements
]

{ #category : #accessing }
OPDiagram >> commonElements: anObject [
	commonElements := anObject
]

{ #category : #initialization }
OPDiagram >> initialize [
	super initialize.
	commonElements := #().
	visibleElements := OrderedCollection new
]

{ #category : #accessing }
OPDiagram >> isOpen [
	^ isOpen
]

{ #category : #accessing }
OPDiagram >> isOpen: aBoolean [
	isOpen := aBoolean
]

{ #category : #accessing }
OPDiagram >> isSelected [
	^ isSelected
]

{ #category : #accessing }
OPDiagram >> isSelected: aBoolean [
	isSelected := aBoolean
]

{ #category : #accessing }
OPDiagram >> layout [
	^ layout
]

{ #category : #accessing }
OPDiagram >> layout: aCollection [

	layout := (aCollection associations sorted: [ :a :b | 
		           a value < b value ]) asOrderedDictionary
]

{ #category : #accessing }
OPDiagram >> model [
	^ model
		"ifNil: [ self project models
				detect:
					[ :each | each class name = self modelType and: [ each name = self modelName ] ] ]"
]

{ #category : #accessing }
OPDiagram >> model: aModel [
	model := aModel
]

{ #category : #accessing }
OPDiagram >> modelName [
	^ (model respondsTo: #name)
		ifTrue: [ model name ]
		ifFalse: [ model className ]
]

{ #category : #accessing }
OPDiagram >> modelType [
	^ (model respondsTo: #typeName)
		ifTrue: [ model typeName ]
		ifFalse: [ model className ]
]

{ #category : #accessing }
OPDiagram >> name [
	^ name
]

{ #category : #accessing }
OPDiagram >> name: aName [
	name := aName
]

{ #category : #copying }
OPDiagram >> newCopy [
	| newView |
	newView := self class ofModel: model fromJsonString: self asJson.
	newView name: 'copy of ' , self name.
	^ newView
]

{ #category : #accessing }
OPDiagram >> order [
	^ order ifNil: [ 0 ]
]

{ #category : #accessing }
OPDiagram >> order: anOrder [
	order := anOrder
]

{ #category : #printing }
OPDiagram >> printOn: aStream [

	super printOn: aStream.
	aStream << '('.
	self name printOn: aStream.
	aStream << '@'.
	self modelName printOn: aStream.
	aStream << ')'
]

{ #category : #accessing }
OPDiagram >> setAllElementsVisible [

	visibleElements := nil
]

{ #category : #converting }
OPDiagram >> updateFromInfo: anInfo [
	self deprecated: 'OPDiagramInfo is no longer used'.
	
	self isOpen: anInfo isOpen.
	self isSelected: anInfo isSelected.
	self order: anInfo order
]

{ #category : #accessing }
OPDiagram >> updateFromRoassalView: aView [
	self
		camera:
			(OPDiagramCamera new
				offset: aView canvas camera position;
				zoom: aView canvas camera scale)
]

{ #category : #accessing }
OPDiagram >> visibleElements [

	self deprecated:
		'Use visibleElementsOrIfNotSet: with block as parameter. Variable visibleElements is not set usually when all elements should be visible'.

	^ self visibleElementsOrIfNotSet: [ {  } ]
]

{ #category : #accessing }
OPDiagram >> visibleElements: aCollection [
	visibleElements := aCollection
]

{ #category : #accessing }
OPDiagram >> visibleElementsOrIfNotSet: aBlock [

	visibleElements ifNil: [ visibleElements := aBlock value ].
	^ visibleElements
]
