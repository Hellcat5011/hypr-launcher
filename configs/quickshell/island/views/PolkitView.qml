import QtQuick
import QtQuick.Layouts
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    signal dismiss()
    
    property bool hasError: false
    

    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        
        RowLayout {
            spacing: 8
            Icons.LockIcon {
                width: 20; height: 20
            }
            Text {
                text: "Authentication Required"
                color: Theme.pillForeground
                font.family: Theme.fontFamily
                font.pixelSize: 16
                font.bold: true
            }
        }
        
        Text {
            Layout.fillWidth: true
            text: (typeof PolkitService !== "undefined" && PolkitService.activeFlow) ? PolkitService.activeFlow.actionId : ""
            color: Theme.pillSubtext
            font.family: Theme.fontFamily
            font.pixelSize: 10
            elide: Text.ElideRight
        }
        
        Text {
            Layout.fillWidth: true
            text: (typeof PolkitService !== "undefined" && PolkitService.activeFlow) ? PolkitService.activeFlow.message : ""
            color: Theme.pillForeground
            font.family: Theme.fontFamily
            font.pixelSize: 14
            wrapMode: Text.Wrap
        }
        
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            
            Rectangle {
                id: pwdField
                anchors.fill: parent
                radius: Theme.radiusSmall
                color: Theme.surfaceVariant
                border.color: root.hasError ? Theme.error : "transparent"
                border.width: root.hasError ? 2 : 0
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8
                    
                    TextInput {
                        id: passwordInput
                        Layout.fillWidth: true
                        color: Theme.pillForeground
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        echoMode: showPwdBtn.checked ? TextInput.Normal : TextInput.Password
                        
                        Keys.onReturnPressed: {
                            if (typeof PolkitService !== "undefined" && PolkitService.activeFlow) {
                                // Assume submit returns false if immediate failure, or triggers a signal
                                // For now, we'll just submit
                                PolkitService.activeFlow.submit(text)
                                root.dismiss()
                            }
                        }
                        Keys.onEscapePressed: {
                            if (typeof PolkitService !== "undefined" && PolkitService.activeFlow) {
                                PolkitService.activeFlow.cancel()
                            }
                            root.dismiss()
                        }
                    }
                    
                    MouseArea {
                        id: showPwdBtn
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        property bool checked: false
                        
                        Icons.EyeIcon {
                            anchors.centerIn: parent
                            width: 16; height: 16
                            // Could toggle strike-through or similar based on checked
                        }
                        
                        onClicked: checked = !checked
                    }
                }
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Item { Layout.fillWidth: true } // spacer
            
            Rectangle {
                Layout.preferredWidth: 80
                Layout.preferredHeight: 32
                radius: Theme.radiusSmall
                color: "transparent"
                border.color: Theme.surfaceVariant
                
                Text {
                    anchors.centerIn: parent
                    text: "Cancel"
                    color: Theme.pillForeground
                    font.family: Theme.fontFamily
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (typeof PolkitService !== "undefined" && PolkitService.activeFlow) {
                            PolkitService.activeFlow.cancel()
                        }
                        root.dismiss()
                    }
                }
            }
            
            Rectangle {
                Layout.preferredWidth: 80
                Layout.preferredHeight: 32
                radius: Theme.radiusSmall
                color: Theme.primary
                
                Text {
                    anchors.centerIn: parent
                    text: "Submit"
                    color: Theme.pillForeground
                    font.family: Theme.fontFamily
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (typeof PolkitService !== "undefined" && PolkitService.activeFlow) {
                            PolkitService.activeFlow.submit(passwordInput.text)
                            root.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    Component.onCompleted: passwordInput.forceActiveFocus()
}
