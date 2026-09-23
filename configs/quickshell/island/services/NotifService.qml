pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

Item {
    id: root

    property var currentNotification: null
    property bool peaceMode: false
    property var history: []

    signal notificationPosted(var notification)

    NotificationServer {
        id: server
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: (notification) => {
            var notif = {
                id: notification.id,
                appName: notification.appName || "",
                icon: notification.icon || notification.appIcon || "",
                summary: notification.summary || "",
                body: notification.body || "",
                urgency: notification.urgency || 1,
                sourceObj: notification
            };

            root.history.unshift(notif); // Add to history

            if (!root.peaceMode) {
                root.currentNotification = notif;
                root.notificationPosted(notif);
            }
        }
    }
}
