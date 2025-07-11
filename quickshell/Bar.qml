import Quickshell // for PanelWindow
import QtQuick // for Text
import Quickshell.Io // for Process
import "./js/colors.js" as C

Variants {
  model: Quickshell.screens;

  delegate: Component {
    PanelWindow {
    // the screen from the screens list will be injected into this
    // property
    property var modelData
    color: C.background
    // we can then set the window's screen to the injected property
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 30

        ClockWidget {
            anchors.centerIn: parent
            color: C.foreground
        }
    
    }
  }
}
