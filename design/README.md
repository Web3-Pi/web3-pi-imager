# UI Prototyping with QT Design Studio

This section is exclusively dedicated to designing and prototyping the User Interface (UI) using QT Design Studio.

The original UI files include dependencies on other project components, which prevent them from being loaded directly into QT Design Studio.

To facilitate prototyping of UI elements, the `design` folder contains mockups and configuration files specifically for QT Design Studio.


### Warning
The `src` directory includes duplicates of these files. Therefore, this subproject is intended solely for UI prototyping purposes.

It is not part of the compiled codebase for the Web3Pi Imager application.
So changes in this subproject will not affect the building and compilation of the target application.


### TODO:
Migrate the source qml files to the latest version of QT and mock the dependencies so that the project meets the requirements of QT Design Studio and it is possible to work on the interface with the source files.