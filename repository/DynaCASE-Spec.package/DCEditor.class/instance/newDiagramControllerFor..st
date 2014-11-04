diagram handling
newDiagramControllerFor: aDiagram
	| d |
	d := {(DCFsm -> DCFsmController).
	(DCUmliteDiagram -> DCUmliteController).
	(DCOmlDiagram -> DCOmlController) } asDictionary.
	d
		at: aDiagram class
		ifPresent: [ :class | 
			^ class new
				model: aDiagram;
				editor: self;
				yourself ]
		ifAbsent: [ self error: 'Unknown diagram type' ]