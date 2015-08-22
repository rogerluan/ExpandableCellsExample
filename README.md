# ExpandableCellsExample
###Simple example of how to create expandable table view cells

![Expandable Cells Icon](/ExpandableCellsExample/Assets.xcassets/AppIcon.appiconset/EC60x60%403x.png?raw=true "Expandable Cells Icon")

In this example, I show one of the possible ways to create expandable table view cells.
What seems to be such an easy task, and present in many applications and customer requirements nowadays, is usually taking too much effort for developers to code, so I thought of a simple way to solve this problem.

I needed to create a simple expandable table view cell and found out that all the libraries that were dealing with this problem, were either not functional or didn't work on latest environment. 

Note that this source code is not a "ready-to-go drag-and-drop" framework. It just shows you _one possible way_ of creating expandable cells.

##Features

- Expandable Table View Cells
- Dynamic table view cell height, which depends on the text view content height
- Auto-resize table view cell upon user interaction on text view content
- Keeps cursor always on focus

The technique used in this example is simple: load everything that you need to be displayed in that given cell, at once (not lazy instantiation). Set the cell height to a determined `collapsedCellHeight`. Then, upon user interaction, expand that cell height to the `expandedCellHeight` (actually calculate the cell height, and not use a constant).

There are many other solutions to this issue, like lazy instantiation (load the expanded cell content upon user interaction - in case it displays content from a web service), or completely change the cell structure upon user interaction - each case depends on your needs. This is *not* the only solution.

#####Feel free to contact me for any questions, suggestions, pull requests, or anything doubts.