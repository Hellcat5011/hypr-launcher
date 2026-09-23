import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../services"
import "../icons" as Icons

Item {
    id: root

    signal dismiss()

    // Track keyboard selection
    property int currentIndex: 0
    property int itemCount: 5

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Repeater {
            id: repeater
            model: [
                { name: "Lock", cmd: "loginctl lock-session", destructive: false },
                { name: "Suspend", cmd: "systemctl suspend", destructive: false },
                { name: "Logout", cmd: "hyprctl dispatch exit", destructive: false },
                { name: "Reboot", cmd: "systemctl reboot", destructive: true },
                { name: "Power Off", cmd: "systemctl poweroff", destructive: true }
            ]

            delegate: Item {
                id: delegateRoot
                Layout.fillWidth: true
                Layout.fillHeight: true

                property bool armed: false
                property string itemName: modelData.name
                property string itemCmd: modelData.cmd
                property bool itemDestructive: modelData.destructive

                Timer {
                    id: armTimer
                    interval: 3000
                    onTriggered: delegateRoot.armed = false
                }

                function triggerAction() {
                    console.log("Power action triggered: " + itemName)
                    if (itemDestructive) {
                        if (armed) {
                            runAction(itemCmd)
                        } else {
                            armed = true
                            armTimer.start()
                        }
                    } else {
                        runAction(itemCmd)
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Theme.radiusSmall
                    color: (delegateRoot.itemDestructive && delegateRoot.armed) ? Theme.error :
                           (index === root.currentIndex || mouseArea.containsMouse ? Theme.surfaceVariant : "transparent")

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8

                        Loader {
                            id: iconLoader
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60

                            onLoaded: {
                                item.width = Qt.binding(function() { return iconLoader.width })
                                item.height = Qt.binding(function() { return iconLoader.height })
                            }

                            sourceComponent: {
                                switch (delegateRoot.itemName) {
                                    case "Lock": return lockIcon;
                                    case "Suspend": return suspendIcon;
                                    case "Logout": return logoutIcon;
                                    case "Reboot": return rebootIcon;
                                    case "Power Off": return powerIcon;
                                }
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: (delegateRoot.itemDestructive && delegateRoot.armed) ? "Press again" : delegateRoot.itemName
                            color: (delegateRoot.itemDestructive && delegateRoot.armed) ? "white" : Theme.pillForeground
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                        }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    z: 10
                    onClicked: {
                        root.currentIndex = index
                        delegateRoot.triggerAction()
                    }
                }
            }
        }
    }

    function runAction(cmd) {
        // Dismiss first so the Loader deactivates this view *after* we've
        // handed off the Process to a persistent parent (Qt.application).
        // Previously, dismiss() destroyed the PowerView (and its children)
        // before the dynamically-created Process had a chance to start.
        var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', Qt.application)
        proc.command = cmd.split(" ")
        proc.onRunningChanged.connect(function() {
            if (!proc.running) proc.destroy()
        })
        root.dismiss()
        proc.running = true
    }

    // Icon components
    Component { id: lockIcon; Icons.LockIcon {} }
    Component { id: suspendIcon; Icons.SuspendIcon {} }
    Component { id: logoutIcon; Icons.LogoutIcon {} }
    Component { id: rebootIcon; Icons.RebootIcon {} }
    Component { id: powerIcon; Icons.PowerIcon {} }

    Keys.onEscapePressed: dismiss()
    Keys.onRightPressed: { currentIndex = Math.min(currentIndex + 1, itemCount - 1) }
    Keys.onLeftPressed: { currentIndex = Math.max(currentIndex - 1, 0) }
    Keys.onReturnPressed: {
        var item = repeater.itemAt(currentIndex)
        if (item) item.triggerAction()
    }
    Component.onCompleted: forceActiveFocus()
}
