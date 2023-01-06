"
I am Spec model to embed Roassal2 into DCEditor.
"
Class {
	#name : #OPCanvasPresenter,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'diagramController',
		'onZoomChange'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #accessing }
OPCanvasPresenter >> attachController: aDiagramController [

	(diagramController := aDiagramController) canvas: self canvas
]

{ #category : #'selection handling' }
OPCanvasPresenter >> canvasClicked: anEvent [

	self deprecated: 'Last click is now handled by OPRSEventLogger'.
	self lastClickPosition: anEvent position.
	self diagramController selectCanvas
]

{ #category : #'selection handling' }
OPCanvasPresenter >> canvasContextClicked: anEvent [

	(OPPragmaPluginMenuBuilder
		 pragmaKeyword: #opCanvasContextMenu:
		 model: self) menuSpec asMenuMorph popUpInWorld
]

{ #category : #private }
OPCanvasPresenter >> cleanCanvas [

	self canvas shapes copy do: #remove
]

{ #category : #private }
OPCanvasPresenter >> cleanView [

	self
		deprecated: 'Use #cleanCanvas instead.'
		transformWith: '`@receiver cleanView' -> '`@receiver cleanCanvas'.
	^ self cleanCanvas
]

{ #category : #'private-focus' }
OPCanvasPresenter >> createCommandContext [
	"Subclases should override it if they provide any selection"

	^ self createCommandContextForSelection: self selectedElements
]

{ #category : #'private-focus' }
OPCanvasPresenter >> createCommandContextForSelection: selectedItems [
	"simple context has no information about selected items"

	^ OPDiagramFigureContext for: self of: selectedItems
	"	^CmdContactBookPresenterContext for: self of: selectedContacts"
]

{ #category : #accessing }
OPCanvasPresenter >> diagramController [
	^ diagramController
]

{ #category : #accessing }
OPCanvasPresenter >> editor [
	^ self owner
]

{ #category : #'private-focus' }
OPCanvasPresenter >> ensureKeyBindingsFor: aWidget [

	self flag: 'Does not work in P11'.
	super ensureKeyBindingsFor: aWidget.
	^ self enableCommanderShortcutsIn: aWidget
]

{ #category : #toolbar }
OPCanvasPresenter >> exportAsPng [

	self flag: 'default name not supported in file browser'.
	OPExportImageDialog new
		title: 'Choose a PNG file to export the diagram';
		okAction: [ :file :zoom | 
			| acceptFile |
			acceptFile := true.
			self ifFileNameNotCompatible: file do: [ acceptFile := false ].
			acceptFile
				ifTrue: [ self exportCanvasToPng: file zoom: zoom ]
				ifFalse: [ self exportAsPng ] ];
		extensions: #( png ) named: 'PNG images';
		open
]

{ #category : #toolbar }
OPCanvasPresenter >> exportAsSvg [

	self flag: 'default name not supported in file browser'.
	StFBSaveFileDialog new
		title: 'Choose a SVG file to export the diagram';
		okAction: [ :file | self exportCanvasToSvg: file ];
		extensions: #( svg ) named: 'SVG images';
		"defaultName:
			self editor diagramController model name asFileName , '.svg';"
			open
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFile [

	self exportCanvasToPng: aFile silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFile silently: aSilentlyBoolean [

	self
		exportCanvasToPng: aFile
		zoom: 1.000000
		silently: aSilentlyBoolean
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFileReference zoom: aNumber [

	self exportCanvasToPng: aFileReference zoom: aNumber silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFileReference zoom: aNumber silently: aSilentlyBoolean [

	| gridShape originalGridColor originalZoom zoom approxResolution jobBlock |
	self ifFileNameNotCompatible: aFileReference do: [ ^ self ].
	approxResolution := aNumber * aNumber
	                    * self canvas encompassingRectangle area.
	zoom := (aNumber squared * self canvas encompassingRectangle area
	         > 500000000
		         ifTrue: [ 
			         (500000000 / self canvas encompassingRectangle area)
				         sqrt roundDownTo: 0.01 ]
		         ifFalse: [ aNumber ]) max: 0.01.

	(aSilentlyBoolean not and: [ (aNumber - zoom) abs > 0.011 ]) ifTrue: [ 
		GrowlMorph
			openWithLabel: 'Warning'
			contents: 'Export zoom was reduced to '
				, (zoom * 100 printShowingDecimalPlaces: 0)
				, ' % zoom due to technical restrictions.'
			backgroundColor: GrowlMorph theme warningBackgroundColor
			labelColor: GrowlMorph theme textColor ].

	gridShape := self canvas shapes detect: [ :each | 
		             each isKindOf: TRCanvasGridShape ].
	originalGridColor := gridShape color.
	originalZoom := self canvas camera scale.
	self diagramController deselectAll.

	jobBlock := [ :job | 
	            approxResolution := zoom * zoom
	                                *
	                                self canvas encompassingRectangle
		                                area.
	            job title:
		            'Exporting diagram - might take '
		            , (approxResolution > 120000000
				             ifTrue: [ 'tens of seconds' ]
				             ifFalse: [ 
					             approxResolution > 1200000
						             ifTrue: [ 'several seconds' ]
						             ifFalse: [ 'a few seconds' ] ]).
	            [ 
	            gridShape color: Color transparent.
	            self canvas camera scale: zoom.

	            self canvas pngExporter 
		            fileName: aFileReference pathString;
		            export ] ensure: [ 
		            job progress: 0.8.
		            originalZoom ifNotNil: [ 
			            self canvas camera scale: originalZoom ].
		            gridShape color: originalGridColor.
		            self canvas signalUpdate ] ].

	aSilentlyBoolean ifTrue: [ ^ jobBlock value: Job new ].
	jobBlock asJob run.

	UIManager default
		inform: (String streamContents: [ :s | 
				 s << 'Image saved to ' << aFileReference pathString.
				 s
					 cr;
					 cr.
				 s << 'Click to open location' ])
		actionOnClick: [ aFileReference openInOSFileBrowser ]
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToSvg: aFileReference [

	self exportCanvasToSvg: aFileReference silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToSvg: aFileReference silently: aSilentlyBoolean [

	| amountOfElements jobBlock |
	self diagramController deselectAll.

	jobBlock := [ :job | 
	            amountOfElements := self canvas elements size.
	            job title:
		            'Exporting diagram - might take '
		            , (amountOfElements > 5000
				             ifTrue: [ 'tens of seconds' ]
				             ifFalse: [ 
					             amountOfElements > 500
						             ifTrue: [ 'several seconds' ]
						             ifFalse: [ 'a few seconds' ] ]).

	            self canvas svgExporter
		            filename: aFileReference;
		            export ].

	aSilentlyBoolean ifTrue: [ ^ jobBlock value: Job new ].
	jobBlock asJob run.

	UIManager default
		inform: (String streamContents: [ :s | 
				 s << 'Image saved to ' << aFileReference pathString.
				 s
					 cr;
					 cr.
				 s << 'Click to open location' ])
		actionOnClick: [ aFileReference openInOSFileBrowser ]
]

{ #category : #toolbar }
OPCanvasPresenter >> ifFileNameNotCompatible: aFileReference do: aBlock [

	| placesWithNonAscii |
	Smalltalk platform isWindows ifFalse: [ ^ self ].
	placesWithNonAscii := OrderedCollection new.
	aFileReference basename isAsciiString ifFalse: [ 
		placesWithNonAscii add: 'file name' ].
	aFileReference parent absolutePath pathString isAsciiString ifFalse: [ 
		placesWithNonAscii add: 'file path' ].
	placesWithNonAscii ifEmpty: [ ^ self ].
	(GrowlMorph
		 label: (String streamContents: [ :s | 
					  s << 'PNG exporter error: Non-ASCII characters in '.
					  placesWithNonAscii asStringOn: s delimiter: ' and ' ])
		 contents: (String streamContents: [ :s | 
					  s
					  <<
						  'Due to a bug, PNG exporter does not support non-ASCII characters anywhere in file paths. Please export the image to a different '.
					  placesWithNonAscii asStringOn: s delimiter: ' and ' ]))
		vanishDelay: 15 seconds;
		backgroundColor: GrowlMorph theme dangerBackgroundColor;
		openInWorld.
	aBlock value
]

{ #category : #initialization }
OPCanvasPresenter >> initialize [

	super initialize.
	onZoomChange := [ :value |  ].
	self script: [ :canvas | self initializeCanvas: canvas ]
]

{ #category : #initialization }
OPCanvasPresenter >> initializeCanvas: aCanvas [

	| canvasController labelMousePos labelMousePosCam labelScale labelCamPos s1 s2 labelLastClick |
	aCanvas
		when: RSMouseRightClick
		do: [ :event | self canvasContextClicked: event ].
	canvasController := RSCanvasController new.
	canvasController interactionsFromArray: { 
			RSKeyNavigationCanvasInteraction new.
			RSZoomableCanvasInteraction new.
			RSScrollBarsCanvasInteraction new }.
	aCanvas @ canvasController.
	aCanvas @ (OPRSSelectableCanvas new
		 rightLeft;
		 yourself).
	aCanvas @ OPRSEventLogger.
	(aCanvas propertyAt: OPRSSelectableCanvas)
		when: RSSelectionEndEvent
		do: [ :evt | self selectedShapes: evt selectedShapes ].

	labelMousePos := RSLabel new
		                 isFixed: true;
		                 translateTo: 400 @ 10;
		                 yourself.
	labelMousePosCam := RSLabel new
		                    isFixed: true;
		                    translateTo: 400 @ 30;
		                    yourself.
	labelScale := RSLabel new
		              isFixed: true;
		              translateTo: 400 @ 50;
		              yourself.
	labelCamPos := RSLabel new
		               isFixed: true;
		               translateTo: 400 @ 70;
		               yourself.
	labelLastClick := RSLabel new
		                  isFixed: true;
		                  translateTo: 400 @ 90;
		                  yourself.
	s1 := RSBox new
		      color: Color green;
		      translateTo: 200 @ 200;
		      yourself.
	s2 := RSBox new
		      color: Color red;
		      translateTo: -200 @ -200;
		      yourself.
	aCanvas
		add: s1;
		add: s2;
		add: labelMousePos;
		add: labelMousePosCam;
		add: labelScale;
		add: labelCamPos;
		add: labelLastClick.
	aCanvas when: RSMouseMove do: [ :e | 
		labelMousePos text: 'mouse pos: ' , e position asString.
		labelMousePosCam text:
			'mouse posFromCam: ' , e positionFromCamera asString.
		labelScale text: 'scale: ' , aCanvas camera scale asString.
		labelCamPos text: 'cam position: ' , aCanvas position asString.
		labelLastClick text: 'last click: '
			,
				(((self canvas propertyAt: OPRSEventLogger) lastOf:
					  RSMouseLeftClick)
					 ifNil: [ 0 @ 0 ]
					 ifNotNil: [ :lastClick | lastClick position ]) asString.
		aCanvas signalUpdate ].

	self flag: #TODO_R3.
	"aCanvas @ (RTGridView new gridSize: 20)."
	^ aCanvas when: RSScaleChangedEvent do: [ :event | 
		  | zoomText |
		  zoomText := (event newScale < 1
			               ifTrue: [ '   ' ]
			               ifFalse: [ '' ])
		              , (event newScale * 100) rounded asString , '%'.
		  onZoomChange value: zoomText.
		  self editor zoomLabel label: ' ' , zoomText ]
]

{ #category : #events }
OPCanvasPresenter >> lastClickPosition: aPoint [

	self deprecated: 'Last click is now handled by OPRSEventLogger'
]

{ #category : #private }
OPCanvasPresenter >> loadElementsFromController [

	self deprecated: 'Control reloading from Controller, not Canvas'.
	[ 
	self currentWorld activeHand showTemporaryCursor: Cursor wait.
	self currentWorld doOneCycle.
	diagramController rebuild.
	diagramController applyDefaultLayout ] ensure: [ 
		self currentWorld activeHand showTemporaryCursor: nil ]
]

{ #category : #accessing }
OPCanvasPresenter >> model [
	^ diagramController model
]

{ #category : #signalling }
OPCanvasPresenter >> reloadView [
	self deprecated: 'Control reloading from Controller, not Canvas'.
	self cleanView.
	diagramController ifNotNil: [ self loadElementsFromController ].
	diagramController ifNotNil: [ diagramController updateView ]
]

{ #category : #accessing }
OPCanvasPresenter >> roassalView [

	self
		deprecated: 'Use #canvas instead.'
		transformWith:
		'`@receiver roassalView' -> '`@receiver canvas'.
	^ self canvas
]

{ #category : #accessing }
OPCanvasPresenter >> selectedElements [

	^ self diagramController selectedElements
]

{ #category : #'selection handling' }
OPCanvasPresenter >> selectedShapes: shapes [
	self diagramController selectedShapes: shapes
]

{ #category : #'as yet unclassified' }
OPCanvasPresenter >> showAllFigures [

	self canvas nodes
		ifEmpty: [ self canvas camera scale: 1 ]
		ifNotEmpty: [ self canvas zoomToFit ]
]

{ #category : #signalling }
OPCanvasPresenter >> signalUpdate [
	self canvas signalUpdate
]

{ #category : #accessing }
OPCanvasPresenter >> whenZoomChanged: aOneArgBlock [
	onZoomChange := aOneArgBlock
]

{ #category : #accessing }
OPCanvasPresenter >> workbench [
	^ self editor workbench
]

{ #category : #accessing }
OPCanvasPresenter >> zoom [
	"1: default zoom
	 2: zoomed in to 200%"

	^ self canvas camera scale
]

{ #category : #accessing }
OPCanvasPresenter >> zoom: aScale [
	"1: default zoom
	 2: zoomed in to 200%"

	(aScale between: 0.05 and: 4)
		ifFalse: [ ^ self ].
	self canvas camera scale: aScale.
	self canvas signalUpdate
]
