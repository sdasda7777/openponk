initialization
createView
	| element shape |
	element := RTElement new.
	shape := RTEllipse new
		size: 10;
		color: Color black.
	element + shape.
	element @ RTDraggable.
	^ element