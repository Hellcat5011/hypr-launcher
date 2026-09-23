pragma Singleton
import QtQuick
import Quickshell.Services.Polkit

Item {
    id: root

    property var activeFlow: null
    property bool isAuthPending: false

    signal authRequested()

    PolkitAgent {
        id: agent
        
        Component.onCompleted: console.log("PolkitAgent created and registered!")
        
        onFlowChanged: {
            if (agent.flow) {
                root.activeFlow = agent.flow;
                root.isAuthPending = true;
                root.authRequested();
            } else {
                root.activeFlow = null;
                root.isAuthPending = false;
            }
        }
    }

    Connections {
        target: root.activeFlow
        function onCompleted() {
            root.isAuthPending = false;
            root.activeFlow = null;
        }
        function onCancelled() {
            root.isAuthPending = false;
            root.activeFlow = null;
        }
    }
}
