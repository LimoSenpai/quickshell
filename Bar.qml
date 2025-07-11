import Quickshell // for PanelWindow
import QtQuick // for Text, basic QML types
import QtQuick.Layouts 1.3 // for RowLayout
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

    implicitHeight: 40
      WorkspaceIndicator {
          height: parent.height
      }
      ClockWidget {
          anchors.centerIn: parent
          color: C.foreground
      }
    }
  }
}
